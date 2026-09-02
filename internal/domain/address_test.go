package domain

import "testing"

func TestNormalizeAddress(t *testing.T) {
	got, err := NormalizeAddress("ABCDEFabcdefABCDEFabcdefABCDEFabcdefABCD")
	if err != nil {
		t.Fatal(err)
	}
	if got != "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd" {
		t.Fatalf("结果错误: %s", got)
	}
	if _, err = NormalizeAddress("0x123"); err == nil {
		t.Fatal("短地址应失败")
	}
}
