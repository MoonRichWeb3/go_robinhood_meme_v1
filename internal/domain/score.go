// 本文件实现聪明钱包评分公式及等级切分。
package domain

import (
	"math"
	"time"
)

// ScoreSample 表示一笔已匹配卖出的已实现盈亏与链上时间。
type ScoreSample struct {
	ProfitUSD float64
	ChainTime time.Time
}

// ScoreResult 是评分公式产出的分数、级别及持久化快照。
type ScoreResult struct {
	Score, WinRate, ProfitUSD float64
	SampleN                   int
	Level                     string
	Scored                    bool
}

// ComputeScore 按固定公式计算评分；无样本时返回 Scored=false。
func ComputeScore(samples []ScoreSample, now time.Time) ScoreResult {
	r := ScoreResult{SampleN: len(samples)}
	if len(samples) == 0 {
		return r
	}
	fresh, wins := 0, 0
	cutoff := now.UTC().Add(-14 * 24 * time.Hour)
	for _, s := range samples {
		r.ProfitUSD += s.ProfitUSD
		if s.ProfitUSD > 0 {
			wins++
		}
		if !s.ChainTime.Before(cutoff) {
			fresh++
		}
	}
	r.WinRate = float64(wins) / float64(len(samples))
	profitNorm := math.Tanh(r.ProfitUSD / 10000)
	sizeNorm := math.Tanh(float64(len(samples)) / 40)
	freshNorm := float64(fresh) / float64(len(samples))
	r.Score = 100*(.40*r.WinRate+.35*math.Max(profitNorm, 0)+.15*sizeNorm+.10*freshNorm) - 20*math.Max(-profitNorm, 0)
	r.Score = math.Max(0, math.Min(100, r.Score))
	if len(samples) < 8 && r.Score > 49 {
		r.Score = 49
	}
	r.Level = ScoreLevel(r.Score)
	r.Scored = true
	return r
}

// ScoreLevel 把 0 至 100 分映射到 S/A/B/C/D 级别。
func ScoreLevel(score float64) string {
	switch {
	case score >= 80:
		return "S"
	case score >= 65:
		return "A"
	case score >= 50:
		return "B"
	case score >= 35:
		return "C"
	default:
		return "D"
	}
}
