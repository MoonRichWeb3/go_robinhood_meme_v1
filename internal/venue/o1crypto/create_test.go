package o1crypto

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

func loadFixture(t *testing.T) (fixture, []EventLog) {
	t.Helper()
	raw, err := os.ReadFile("../testdata/o1crypto_launched.json")
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
	f, logs := loadFixture(t)
	tx := TxContext{From: f.Tx.From, Hash: f.Tx.Hash, Value: f.Tx.Value, BlockNumber: f.Tx.BlockNumber, TxIndex: f.Tx.TxIndex, ChainTime: time.Unix(f.Tx.Timestamp, 0), Logs: logs}
	got, err := DecodeCreate(logs[0], tx)
	if err != nil {
		t.Fatal(err)
	}
	if got.TokenAddress != "0x5555555555555555555555555555555555555555" ||
		got.PoolID != "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" ||
		got.CreatorEvent != "0x6666666666666666666666666666666666666666" ||
		got.QuoteSymbol != "USDG" || got.QuoteDecimals != 6 ||
		got.TickSpacing != 200 || got.Supply != "1000000" ||
		got.Hooks != "0x441f773b3bb1ed4c6457d0528624112e43c02acc" ||
		got.NativeLaunchFeeWei != "1000000000000000" {
		t.Fatalf("解码字段不正确: %+v", got)
	}
}

func TestDecodeCreateRejectsWrongInitializeLength(t *testing.T) {
	f, logs := loadFixture(t)
	logs[1].Data = logs[1].Data[:159]
	_, err := DecodeCreate(logs[0], TxContext{From: f.Tx.From, Hash: f.Tx.Hash, Value: f.Tx.Value, ChainTime: time.Now(), Logs: logs})
	if err == nil {
		t.Fatal("错误长度必须失败")
	}
}

func TestDecodeCreateKeepsFactoryClassificationOnHookMismatch(t *testing.T) {
	f, logs := loadFixture(t)
	logs[1].Data = append([]byte(nil), logs[1].Data...)
	logs[1].Data[95] ^= 1
	got, err := DecodeCreate(logs[0], TxContext{From: f.Tx.From, Hash: f.Tx.Hash, Value: f.Tx.Value, ChainTime: time.Now(), Logs: logs})
	if err != nil {
		t.Fatal(err)
	}
	if got.HookWarning == "" || got.IndexCategory() != "o1_crypto" {
		t.Fatalf("Hook 异常仍应保留工厂分类: %+v", got)
	}
}
