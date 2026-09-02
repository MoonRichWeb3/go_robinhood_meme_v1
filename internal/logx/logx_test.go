package logx

import (
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
