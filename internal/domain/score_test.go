package domain

import (
	"math"
	"testing"
	"time"
)

func TestComputeScoreFormula(t *testing.T) {
	now := time.Date(2026, 9, 2, 0, 0, 0, 0, time.UTC)
	s := make([]ScoreSample, 8)
	for i := range s {
		s[i] = ScoreSample{ProfitUSD: 1250, ChainTime: now.Add(-time.Duration(i) * 24 * time.Hour)}
	}
	got := ComputeScore(s, now)
	want := 100 * (.4 + .35*math.Tanh(1) + .15*math.Tanh(.2) + .1)
	if math.Abs(got.Score-want) > 1e-9 || got.Level != "A" {
		t.Fatalf("got=%+v want=%f", got, want)
	}
}

func TestComputeScoreSmallSampleCap(t *testing.T) {
	now := time.Now().UTC()
	got := ComputeScore([]ScoreSample{{ProfitUSD: 100000, ChainTime: now}}, now)
	if got.Score != 49 || got.Level != "C" {
		t.Fatalf("got=%+v", got)
	}
	if ComputeScore(nil, now).Scored {
		t.Fatal("无样本不应标记已评分")
	}
}
