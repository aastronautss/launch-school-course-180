CREATE TABLE expenses (
  id serial PRIMARY KEY,
  amount DECIMAL(6, 2) NOT NULL,
  memo VARCHAR(25) NOT NULL,
  created_on DATE DEFAULT NOW() NOT NULL
);

ALTER TABLE expenses ADD CONSTRAINT positive_amount CHECK (amount > 0);
