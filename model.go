package model

import (
	_ "github.com/mattn/go-sqlite3"
	_ "github.com/lib/pq"
	"time"
)

type BudgetType string
type TransactionType string

const (
	Income TransactionType  = "INCOME"
	Outcome TransactionType = "OUTCOME"

	GoalBudget BudgetType   = "GOAL_BUDGET"
	NormalBudget BudgetType = "NORMAL_BUDGET"
)

type Category struct {
	Id                      int64
	Parent                  Category
	Name                    string
	Description             string
	CreatedAt               time.Time
	UpdatedAt               time.Time
}

type BudgetDate struct {
	Id    int64
	Month int8
	Year  int8
}

type Budget struct {
	Id              int64
	BudgetType      BudgetType
	Category        Category
	BudgetDate      BudgetDate
	Budgets         []BudgetItem
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

type BudgetItem struct {
	Id              int64
	Budget          Budget
	Amount          float32
	RollOver        bool
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

type Transaction struct {
	Id              int64
	TransactionType TransactionType
	ProcessDate     time.Time
	ValueDate       time.Time
	Cleared         bool
	Recurrent       bool
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

