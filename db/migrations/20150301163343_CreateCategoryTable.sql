
-- +goose Up
-- SQL in section 'Up' is executed when this migration is applied

CREATE SCHEMA public;


CREATE TABLE IF NOT EXISTS bdg_user (
  usr_id        SERIAL PRIMARY KEY                                  NOT NULL,
  usr_firstname VARCHAR(100)                                        NOT NULL,
  usr_lastname  VARCHAR(100)                                        NOT NULL,
  usr_urlimage  VARCHAR(100),
  usr_email     VARCHAR(100) UNIQUE                                 NOT NULL,
  usr_password  VARCHAR(100)                                        NOT NULL,
  usr_networth  FLOAT                                               NOT NULL  DEFAULT 0,
  usr_createdat TIMESTAMP WITHOUT TIME ZONE                         NOT NULL  DEFAULT now(),
  CONSTRAINT CST_USER_NAME UNIQUE (usr_email)
);


CREATE TABLE IF NOT EXISTS bdg_budget (
  bdg_id          SERIAL PRIMARY KEY          NOT NULL,
  bdg_name        VARCHAR(100)                NOT NULL,
  bdg_description VARCHAR(255),
  bdg_balance     FLOAT                       NOT NULL DEFAULT 0,
  bdg_createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT current_date
);

CREATE TABLE IF NOT EXISTS bdg_user_budget (
  bdg_id        INTEGER                     NOT NULL,
  usr_id        INTEGER                     NOT NULL,
  bdg_createdat TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  PRIMARY KEY (bdg_id, usr_id),
  FOREIGN KEY (bdg_id) REFERENCES bdg_budget (bdg_id),
  FOREIGN KEY (usr_id) REFERENCES bdg_user (usr_id)
);

CREATE TABLE IF NOT EXISTS bdg_account_type (
  aty_id        SERIAL PRIMARY KEY NOT NULL,
  aty_code      VARCHAR(50)        NOT NULL,
  aty_name      VARCHAR(100)       NOT NULL,
  aty_offbudget BOOLEAN            NOT NULL DEFAULT FALSE,
  CONSTRAINT CST_ACCOUNT_TYPE_CODE UNIQUE (aty_code)
);

CREATE TABLE IF NOT EXISTS bdg_account (
  acc_id          SERIAL PRIMARY KEY          NOT NULL,
  bdg_id          INTEGER                     NOT NULL,
  aty_id          INTEGER                     NOT NULL,
  acc_name        VARCHAR(100)                NOT NULL,
  acc_description VARCHAR(255),
  acc_balance     FLOAT                       NOT NULL DEFAULT 0,
  acc_createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  FOREIGN KEY (aty_id) REFERENCES bdg_account_type (aty_id),
  FOREIGN KEY (bdg_id) REFERENCES bdg_budget (bdg_id),
  CONSTRAINT CTR_ACCOUNT_TYPE_NAME_BUDGET UNIQUE (bdg_id, aty_id, acc_name)
);



--representing a month
CREATE TABLE IF NOT EXISTS bdg_date (
  dat_id    SERIAL PRIMARY KEY NOT NULL,
  dat_year  INTEGER,
  dat_month INTEGER,
  CONSTRAINT CTR_MONTH_YEAR UNIQUE (dat_month, dat_year),
  CHECK (dat_month >= 1 AND dat_month <= 12),
  CHECK (dat_year >= 2015 AND dat_month <= 2050)
);




--category that hold all the created categories, by user or system default.
CREATE TABLE IF NOT EXISTS bdg_category (
  cat_id          SERIAL PRIMARY KEY          NOT NULL,
  parent_cat_id   INTEGER,
  cat_name        VARCHAR(100)                NOT NULL,
  cat_description VARCHAR(255),
  cat_default     BOOLEAN                                        DEFAULT FALSE, --if true then a category created by mybudget application
  cat_createdat   TIMESTAMP WITHOUT TIME ZONE NOT NULL           DEFAULT now(),
  cat_updatedat   TIMESTAMP WITHOUT TIME ZONE NOT NULL           DEFAULT now(),
  FOREIGN KEY (parent_cat_id) REFERENCES bdg_category (cat_id),
  CONSTRAINT CTR_CATEGORY_PARENT_NAME UNIQUE (cat_id, parent_cat_id, cat_name)
);

--> category save all category....filter by budget....
--> for a budget we list all the categories....
      -- one category can be used in many budgets
      -- one budget can hold many categories

--Categories in the budget
CREATE TABLE IF NOT EXISTS bdg_budget_category (
  bca_id            SERIAL PRIMARY KEY NOT NULL,
  cat_id            INTEGER            NOT NULL,
  bdg_id            INTEGER            NOT NULL,
  dat_id            INTEGER            NOT NULL,
  bca_name          VARCHAR(100),
  bca_note          VARCHAR(255),
  bca_income        FLOAT              NOT NULL DEFAULT 0, --total income (sum money budgeted) since the beginning -- redundant data
  bca_expence       FLOAT              NOT NULL DEFAULT 0, --total expense (sum of transaction) since the beginning --redundant data
  bca_goalamout     FLOAT              NOT NULL DEFAULT 0, --amount of the goal to achieve.
  bca_goallimitdate TIMESTAMP WITHOUT TIME ZONE, --goal limit date
  FOREIGN KEY (cat_id) REFERENCES bdg_category (cat_id),
  FOREIGN KEY (bdg_id) REFERENCES bdg_budget (bdg_id),
  FOREIGN KEY (dat_id) REFERENCES bdg_date (dat_id),
  CONSTRAINT CTR_BUDGET_CATEGORY UNIQUE (cat_id, bdg_id, dat_id)
);

CREATE TABLE IF NOT EXISTS bdg_payee (
  pay_id         SERIAL PRIMARY KEY          NOT NULL,
  bdg_id         INTEGER                     NOT NULL,
  pay_name       VARCHAR(100)                NOT NULL,
  default_acc_id INTEGER, --default account to use
  default_bca_id INTEGER, --default budget item id
  acc_createdat  TIMESTAMP WITHOUT TIME ZONE NOT NULL           DEFAULT now(),
  FOREIGN KEY (bdg_id) REFERENCES bdg_budget (bdg_id),
  FOREIGN KEY (default_acc_id) REFERENCES bdg_account (acc_id),
  FOREIGN KEY (default_bca_id) REFERENCES bdg_budget_category (bca_id),
  CONSTRAINT CTR_PAYEE_NAME_BUDGET UNIQUE (bdg_id, pay_name)
);

--Transaction
CREATE TABLE IF NOT EXISTS bdg_transaction (
  tra_id        SERIAL PRIMARY KEY          NOT NULL,
--tra_linkedid  INTEGER, -- link to this transaction (multiple account for one transaction, or transfer (from transaction and to transaction)
  dat_id        INTEGER                     NOT NULL, -- date
  cat_id        INTEGER                     NOT NULL, -- category
  pay_id        INTEGER, --payee
  acc_id        INTEGER                     NOT NULL, -- the account to be used for this transaction, or source account in case of transfer
  --dest_acc_id   INTEGER, --in case of transfer destination account.
  tra_note      VARCHAR(255),
  tra_amount    FLOAT, --amount budgeted this month
  tra_valuedate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  tra_createdat TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  tra_type      VARCHAR(3), -- enum Transaction, transfer, reconciliation, starting balance
  FOREIGN KEY (dat_id) REFERENCES bdg_date (dat_id),
  FOREIGN KEY (cat_id) REFERENCES bdg_category (cat_id),
  FOREIGN KEY (pay_id) REFERENCES bdg_payee (pay_id),
  FOREIGN KEY (acc_id) REFERENCES bdg_account (acc_id),
  CONSTRAINT CTR_UNIQUE_TRANSACTION UNIQUE (dat_id, cat_id, pay_id, acc_id),
  CHECK (tra_type IN ('TRA', 'TRS', 'STB', 'REC'))
);


/*--Categories in the budget

--TODOwe can think about a parent transaction that hold
-- splitting transaction and transfer...

-- transfer is a double transaction
-- TODO think about an unification of transfer and type transfer
CREATE TABLE bdg_transfer_account (
  tra_id             INTEGER,
  source_acc_id      INTEGER,
  destination_acc_id INTEGER,
  amount             FLOAT
);

*/




INSERT INTO bdg_user (usr_firstname, usr_lastname, usr_urlimage, usr_email, usr_password)
VALUES ('John', 'Malkovich', 'me.jpg', 'jmlk@gmail.com', 'my_very_secret_password');

INSERT INTO bdg_user (usr_firstname, usr_lastname, usr_urlimage, usr_email, usr_password)
VALUES ('Milla', 'Yougovich', 'me.jpg', 'milla@gmail.com', 'guess_what?_its_a_clear_password_:)');

INSERT INTO bdg_budget (bdg_name, bdg_description)
VALUES ('Family Budget', 'Our family Budget');

INSERT INTO bdg_budget (bdg_name, bdg_description)
VALUES ('Business Budget', 'Our family Business Budget');

INSERT INTO bdg_user_budget (bdg_id, usr_id)
  SELECT
    usr_id,
    bdg_id
  FROM bdg_user, bdg_budget
  WHERE usr_id IN (1, 2)
        AND bdg_budget.bdg_id = 1;

INSERT INTO bdg_user_budget (bdg_id, usr_id)
  SELECT
    usr_id,
    bdg_id
  FROM bdg_user, bdg_budget
  WHERE usr_id = 1
        AND bdg_budget.bdg_id = 2;


INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Checking', 'CHEKING', FALSE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Savings', 'SAVINGS', FALSE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Credit Cards', 'CREDITCARD', FALSE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Cash', 'CASH', FALSE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Paypal', 'PAYPAL', FALSE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('BitCoin', 'BITCOIN', FALSE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Investment Accounts', 'INVEST', TRUE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Mortgage', 'MORTAGE', TRUE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Other Assets', 'OTHASSETS', TRUE);
INSERT INTO bdg_account_type (aty_name, aty_code, aty_offbudget) VALUES ('Other Liabilities', 'OTHLIAB', TRUE);


INSERT INTO bdg_account (bdg_id, aty_id, acc_name, acc_description)
VALUES (1, 1, 'Ingdirect', 'Our ingdirect Checking account');

INSERT INTO bdg_account (bdg_id, aty_id, acc_name, acc_description)
VALUES (1, 2, 'Livret A SG', 'Livret A saving account');

INSERT INTO bdg_account (bdg_id, aty_id, acc_name, acc_description)
VALUES (1, 7, 'Compte PEA Boursourama', 'Stock investement account');

INSERT INTO bdg_account (bdg_id, aty_id, acc_name, acc_description)
VALUES (2, 1, 'Ingdirect myBudget', 'My business account for mybudet application');

INSERT INTO bdg_account (bdg_id, aty_id, acc_name, acc_description)
VALUES (2, 5, 'Paypal myBudget', 'My Paypal account for mybudget application');


INSERT INTO bdg_payee (bdg_id, pay_name) VALUES (1, 'Pizzaria Venezia');
INSERT INTO bdg_payee (bdg_id, pay_name) VALUES (1, 'Monoprix');
INSERT INTO bdg_payee (bdg_id, pay_name) VALUES (1, 'La poste');


INSERT INTO bdg_category (cat_name) VALUES ('Monthly Bills');
INSERT INTO bdg_category (cat_name) VALUES ('Everyday Expenses');
INSERT INTO bdg_category (cat_name) VALUES ('Rainy day funds');

INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (1, 'Rent');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (1, 'Phone');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (1, 'Internet');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (1, 'Electricity');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (1, 'Natural Gas');
--
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (2, 'Groceries');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (2, 'Restaurants');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (2, 'Medical');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (2, 'Clothes');
--
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (3, 'Emergency fund');
INSERT INTO bdg_category (parent_cat_id, cat_name) VALUES (3, 'Birthdays');

-- +goose Down
-- SQL section 'Down' is executed when this migration is rolled back

DROP SCHEMA public CASCADE;