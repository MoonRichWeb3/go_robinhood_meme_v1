package domain

import "testing"

func TestCalcEventID(t *testing.T) {
	got, err := CalcEventID(51337623, 12, 7)
	if err != nil || got != "5133762300120007" {
		t.Fatalf("got=%s err=%v", got, err)
	}
	got, err = CalcEventID(100000000, 1, 1)
	if err == nil || got != "10000000000010001" {
		t.Fatalf("超宽值被截断: %s", got)
	}
}
