package pons

import (
	"encoding/hex"
	"encoding/json"
	"os"
	"strings"
	"testing"
	"time"
)

type fixture struct {
	Tx struct {
		From        string `json:"from"`
		To          string `json:"to"`
		Hash        string `json:"hash"`
		Value       string `json:"value"`
		BlockNumber uint64 `json:"block_number"`
		TxIndex     uint64 `json:"tx_index"`
		Timestamp   int64  `json:"timestamp"`
	}
	Logs []struct {
		Address  string   `json:"address"`
		Topics   []string `json:"topics"`
		Data     string   `json:"data"`
		LogIndex uint64   `json:"log_index"`
	}
}

func loadFixture(t *testing.T, name string) (fixture, []EventLog) {
	t.Helper()
	raw, err := os.ReadFile("../testdata/" + name)
	if err != nil {
		t.Fatal(err)
	}
	var f fixture
	if err = json.Unmarshal(raw, &f); err != nil {
		t.Fatal(err)
	}
	logs := make([]EventLog, len(f.Logs))
	for i, item := range f.Logs {
		data, err := hex.DecodeString(strings.TrimPrefix(item.Data, "0x"))
		if err != nil {
			t.Fatal(err)
		}
		logs[i] = EventLog{Address: item.Address, Topics: item.Topics, Data: data, LogIndex: item.LogIndex}
	}
	return f, logs
}

func TestDecodeCreateFixture(t *testing.T) {
	f, logs := loadFixture(t, "pons_token_launched.json")
	tx := TxContext{From: f.Tx.From, To: f.Tx.To, Hash: f.Tx.Hash, BlockNumber: f.Tx.BlockNumber, TxIndex: f.Tx.TxIndex, ChainTime: time.Unix(f.Tx.Timestamp, 0), Logs: logs}
	got, err := DecodeCreate(logs[0], tx)
	if err != nil {
		t.Fatal(err)
	}
	if got.TokenAddress != "0x1111111111111111111111111111111111111111" ||
		got.CurveAddress != "0x2222222222222222222222222222222222222222" ||
		got.Deployer != "0x3333333333333333333333333333333333333333" ||
		got.PairSymbol != "USDG" || got.PairDecimals != 6 ||
		got.LaunchConfigID != "1" || got.GraduationThreshold != "1000" ||
		got.FirstBuyQuote != "100" || got.FirstBuyTokens != "200" ||
		got.LaunchEntry != "launch_and_buy" || got.LogIndex != 7 {
		t.Fatalf("解码字段不正确: %+v", got)
	}
}

func TestDecodeCreateRejectsWrongDataLength(t *testing.T) {
	f, logs := loadFixture(t, "pons_token_launched.json")
	logs[0].Data = logs[0].Data[:95]
	_, err := DecodeCreate(logs[0], TxContext{From: f.Tx.From, Hash: f.Tx.Hash, ChainTime: time.Now(), Logs: logs})
	if err == nil {
		t.Fatal("错误长度必须失败")
	}
}
