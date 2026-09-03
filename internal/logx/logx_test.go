package logx

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestRenderUsesChineseKeys(t *testing.T) {
	got := Render("聪明钱-买入", map[string]any{"类型": "买入", "成交单价U": "", "钱包名": "示例 钱包"})
	for _, forbidden := range []string{"kind=", "spot_quote=", "exec_usd="} {
		if strings.Contains(got, forbidden) {
			t.Fatalf("包含英文键 %q: %s", forbidden, got)
		}
	}
	if !strings.Contains(got, `钱包名="示例 钱包"`) {
		t.Fatalf("含空格值未正确引用: %s", got)
	}
}

func TestOpenDirFile(t *testing.T) {
	file, err := OpenDirFile("")
	if err != nil || file != nil {
		t.Fatalf("空目录应跳过: file=%v err=%v", file, err)
	}
	dir := t.TempDir()
	file, err = OpenDirFile(dir)
	if err != nil {
		t.Fatal(err)
	}
	defer file.Close()
	logger := New(file, "info")
	logger.Info("启动", map[string]any{"类型": "测试"})
	body, err := os.ReadFile(filepath.Join(dir, FileName))
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(body), "[启动]") {
		t.Fatalf("未写入日志文件: %s", body)
	}
}
