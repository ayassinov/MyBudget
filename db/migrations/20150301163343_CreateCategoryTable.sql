-- +goose Up
-- SQL in section 'Up' is executed when this migration is applied

CREATE TABLE IF NOT EXISTS bdg_user (
  id        SERIAL PRIMARY KEY                                  NOT NULL,
  uuid      VARCHAR(10)                                         NOT NULL,
  firstname VARCHAR(100)                                        NOT NULL,
  lastname  VARCHAR(100)                                        NOT NULL,
  urlimage  VARCHAR(100),
  email     VARCHAR(100) UNIQUE                                 NOT NULL,
  password  VARCHAR(100)                                        NOT NULL,
  networth  FLOAT                                               NOT NULL  DEFAULT 0,
  createdat TIMESTAMP WITHOUT TIME ZONE                         NOT NULL  DEFAULT now(),
  CONSTRAINT CST_USER_NAME UNIQUE (email),
  CONSTRAINT CST_USER_UUID UNIQUE (uuid)
);

-- This is the main entry point between the user and his money :)
--When creating check only one name by user
-- add any option, like currency used, local
CREATE TABLE IF NOT EXISTS bdg_plan (
  id          SERIAL PRIMARY KEY          NOT NULL,
  name        VARCHAR(100)                NOT NULL,
  description VARCHAR(255),
  balance     FLOAT                       NOT NULL DEFAULT 0,
  createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now()
);

-- many user can share the same budget plan
-- One user can have many budget plan
--add role, or profile id like (admin, viewer, create transaction, delete privilege so forth)
CREATE TABLE IF NOT EXISTS bdg_user_plan (
  plan_id   BIGINT                      NOT NULL,
  user_id   BIGINT                      NOT NULL,
  createdat TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  PRIMARY KEY (plan_id, user_id),
  FOREIGN KEY (plan_id) REFERENCES bdg_plan (id),
  FOREIGN KEY (user_id) REFERENCES bdg_user (id)
);

-- The type of account (Checking, Credit card, Cash, PayPal,..)
CREATE TABLE IF NOT EXISTS bdg_account_type (
  id   SERIAL PRIMARY KEY NOT NULL,
  code VARCHAR(50)        NOT NULL,
  name VARCHAR(100)       NOT NULL,
  CONSTRAINT CST_ACCOUNT_TYPE_CODE UNIQUE (code)
);

-- Any account that the user want to track, (where is the money question ?)
CREATE TABLE IF NOT EXISTS bdg_account (
  id          SERIAL PRIMARY KEY          NOT NULL,
  plan_id     BIGINT                      NOT NULL,
  type_id     BIGINT                      NOT NULL,
  name        VARCHAR(100)                NOT NULL,
  description VARCHAR(255),
  balance     FLOAT                       NOT NULL DEFAULT 0,
  offbudget   BOOLEAN                     NOT NULL DEFAULT FALSE,
  createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  FOREIGN KEY (plan_id) REFERENCES bdg_plan (id),
  FOREIGN KEY (type_id) REFERENCES bdg_account_type (id),
  CONSTRAINT CTR_ACCOUNT_TYPE_NAME_BUDGET UNIQUE (plan_id, type_id, name)
);

--Simplify date querying we associate for every Month Budget an Id
CREATE TABLE IF NOT EXISTS bdg_date (
  id    SERIAL PRIMARY KEY NOT NULL,
  year  SMALLINT,
  month SMALLINT,
  CONSTRAINT CTR_MONTH_YEAR UNIQUE (month, year),
  CHECK (month >= 1 AND month <= 12),
  CHECK (year >= 2015)
);


--date_id, plan_id, cat_id
--category that hold all the created categories, by user or system default.
--when user rename default category, create new one attached to that user
-- hidden for user ?
CREATE TABLE IF NOT EXISTS bdg_category (
  id          SERIAL PRIMARY KEY          NOT NULL,
  parent_id   BIGINT,
  user_id     BIGINT, -- if null it's default category
  name        VARCHAR(100)                NOT NULL,
  description VARCHAR(255),
  isdefault   BOOLEAN                                        DEFAULT FALSE, --if true then a default category
  FOREIGN KEY (parent_id) REFERENCES bdg_category (id),
  CONSTRAINT CTR_CATEGORY_PARENT_NAME UNIQUE (id, user_id, parent_id, name)
);


--cat id can be created by user or default. (if user don't want to use default category we remove this link)
-- a budget is a category and a plan
CREATE TABLE IF NOT EXISTS bdg_budget (
  id          SERIAL PRIMARY KEY          NOT NULL,
  plan_id     BIGINT                      NOT NULL,
  category_id BIGINT                      NOT NULL,
  balance     FLOAT                                          DEFAULT 0,
  target      FLOAT                                          DEFAULT 0,
  createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL           DEFAULT now(),
  FOREIGN KEY (plan_id) REFERENCES bdg_plan (id),
  FOREIGN KEY (category_id) REFERENCES bdg_category (id),
  CONSTRAINT CTR_BUDGET_PLAN_CATEGORY UNIQUE (plan_id, category_id),
  CHECK (target >= 0)
);

CREATE TABLE IF NOT EXISTS bdg_budget_date (
  budget_id BIGINT                      NOT NULL,
  date_id   BIGINT                      NOT NULL,
  budgeded  FLOAT                       NOT NULL           DEFAULT 0,
  note      VARCHAR(255),
  createdat TIMESTAMP WITHOUT TIME ZONE NOT NULL           DEFAULT now(),
  PRIMARY KEY (budget_id, date_id),
  FOREIGN KEY (budget_id) REFERENCES bdg_budget (id),
  FOREIGN KEY (date_id) REFERENCES bdg_date (id),
  CHECK (budgeded >= 0)
);


/*CREATE TABLE IF NOT EXISTS bdg_plan_date (
  plan_id       BIGINT NOT NULL,
  date_id       BIGINT NOT NULL,
  balance       FLOAT,
  budgeded      FLOAT,
  fromlastMonth FLOAT
);*/


CREATE TABLE IF NOT EXISTS bdg_payee (
  id        SERIAL PRIMARY KEY          NOT NULL,
  plan_id   BIGINT                      NOT NULL,
  name      VARCHAR(100)                NOT NULL,
-- account_id BIGINT, --default account to use
-- budget_id  BIGINT, --default budget item id
  createdat TIMESTAMP WITHOUT TIME ZONE NOT NULL           DEFAULT now(),
  FOREIGN KEY (plan_id) REFERENCES bdg_plan (id),
-- FOREIGN KEY (account_id) REFERENCES bdg_account (id),
-- FOREIGN KEY (budget_id) REFERENCES bdg_budget (id),
  CONSTRAINT CTR_PAYEE_NAME_BUDGET UNIQUE (plan_id, name)
);

--split transaction between many account or budget can be done from UI as result we will create as many transaction as
-- the user wanted....we may need a table that associate them together...
-- grouped_transaction(id, transaction_id, the grouping or the reason name)

--Transaction
CREATE TABLE IF NOT EXISTS bdg_transaction (
  id         SERIAL PRIMARY KEY          NOT NULL,
--tra_linkedid  INTEGER, -- link to this transaction (multiple account for one transaction, or transfer (from transaction and to transaction)
  date_id    INTEGER                     NOT NULL, -- date
  budget_id  INTEGER                     NOT NULL, -- category
  payee_id   INTEGER, --payee
  account_id INTEGER                     NOT NULL, -- the account to be used for this transaction, or source account in case of transfer
  note       VARCHAR(255),
  amount     FLOAT, --amount budgeted this month
  valuedate  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  createdat  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  type       VARCHAR(3), -- enum Transaction, transfer, reconciliation, starting balance
  cleared    BOOLEAN                              DEFAULT TRUE,
  FOREIGN KEY (date_id) REFERENCES bdg_date (id),
  FOREIGN KEY (budget_id) REFERENCES bdg_budget (id),
  FOREIGN KEY (payee_id) REFERENCES bdg_payee (id),
  FOREIGN KEY (account_id) REFERENCES bdg_account (id),
  CONSTRAINT CTR_UNIQUE_TRANSACTION UNIQUE (date_id, budget_id, payee_id, account_id),
  CHECK (type IN ('TRA', 'TRS', 'STB', 'REC'))
);


-- +goose Down
-- SQL section 'Down' is executed when this migration is rolled back

DROP TABLE bdg_transaction CASCADE;
DROP TABLE bdg_budget_date CASCADE;
DROP TABLE bdg_budget CASCADE;
DROP TABLE bdg_payee CASCADE;
DROP TABLE bdg_date CASCADE;
DROP TABLE bdg_category CASCADE;
DROP TABLE bdg_account CASCADE;
DROP TABLE bdg_account_type CASCADE;
DROP TABLE bdg_user_plan CASCADE;
DROP TABLE bdg_plan CASCADE;
DROP TABLE bdg_user CASCADE;
