package vim

import (
	"fmt"
	"time"

	"github.com/neovim/go-client/nvim"
)

type Callbacker struct {
	vim *nvim.Nvim
}

func NewCallbacker(v *nvim.Nvim) *Callbacker {
	return &Callbacker{
		vim: v,
	}
}

// TriggerCallback triggers the callback with id registered in lua
func (cb *Callbacker) TriggerCallback(id string, success bool, timeTaken time.Duration) error {
	// assemble stats table
	stats := fmt.Sprintf(`{ success = %t, time_taken = %d }`, success, timeTaken.Microseconds())

	// trigger callback
	return cb.vim.ExecLua(fmt.Sprintf(`require("dbee.handler.__callbacks").trigger("%s", %s)`, id, stats), nil)
}
