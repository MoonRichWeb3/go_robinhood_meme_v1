// Package logx 统一渲染中文标签与中文键名的结构化标准输出。
package logx

import (
	"fmt"
	"io"
	"log"
	"sort"
	"strings"
	"sync"
	"time"
)

// Logger 是并发安全的中文结构化日志器。
type Logger struct {
	mu    sync.Mutex
	out   *log.Logger
	level int
}

// New 创建日志器；支持 debug、info、warn、error 四级。
func New(w io.Writer, level string) *Logger {
	levels := map[string]int{"debug": 0, "info": 1, "warn": 2, "error": 3}
	n, ok := levels[strings.ToLower(level)]
	if !ok {
		n = 1
	}
	return &Logger{out: log.New(w, "", 0), level: n}
}

// Info 输出 info 级中文结构化日志。
func (l *Logger) Info(tag string, fields map[string]any) {
	if l.level <= 1 {
		l.write(tag, fields)
	}
}

// Error 输出始终可见的错误日志；调用方未给业务类型时补“错误”。
func (l *Logger) Error(fields map[string]any) {
	copyFields := clone(fields)
	if _, ok := copyFields["类型"]; !ok {
		copyFields["类型"] = "错误"
	}
	l.write("错误", copyFields)
}

// Render 将标签与字段稳定渲染成单行；时间缺失时补当前 UTC。
func Render(tag string, fields map[string]any) string {
	f := clone(fields)
	if _, ok := f["时间"]; !ok {
		f["时间"] = time.Now().UTC().Format(time.RFC3339)
	}
	keys := make([]string, 0, len(f))
	for k := range f {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	parts := make([]string, 0, len(keys)+1)
	parts = append(parts, "["+tag+"]")
	for _, k := range keys {
		v := fmt.Sprint(f[k])
		if strings.ContainsAny(v, " \t\n\"") {
			v = strings.ReplaceAll(v, `"`, `\"`)
			v = `"` + v + `"`
		}
		parts = append(parts, k+"="+v)
	}
	return strings.Join(parts, " ")
}
func (l *Logger) write(tag string, fields map[string]any) {
	l.mu.Lock()
	defer l.mu.Unlock()
	l.out.Print(Render(tag, fields))
}
func clone(in map[string]any) map[string]any {
	out := make(map[string]any, len(in)+1)
	for k, v := range in {
		out[k] = v
	}
	return out
}
