---
layout: note
title: The Smith Manoeuvre
date: 2026-07-07
priority: 60
excerpt: >
  Converting non-deductible mortgage interest into deductible
  investment-loan interest. A leverage strategy first, a tax strategy
  second.
---

> The Smith Manoeuvre involves leverage, tax-deductibility rules, and rigorous tracking. It is one of the more dangerous strategies in this series. Consider talking to a [Smith Manoeuvre Certified Professional](https://smithman.ca/find-an-smcp) or another qualified tax professional before attempting it.

The Smith Manoeuvre converts non-deductible mortgage interest into deductible investment-loan interest, while preserving the same total debt balance. It doesn't *reduce* leverage — it changes the tax character of debt you already have. It's a leverage strategy first, a tax strategy second.

## The setup

In Canada, the interest paid on your principal residence's mortgage is not tax-deductible. The interest on a loan used to acquire income-producing investments generally is. The Smith Manoeuvre is the canonical technique for shifting from the first category to the second over time, without taking on additional total debt.

It has two parts:

1. **Borrow against home equity** through a Home Equity Line of Credit (HELOC), and invest the proceeds in income-producing assets.
2. **Deduct the HELOC interest** against your income, since the borrowed money was used for an income-producing investment.

The strategy assumes a *re-advanceable mortgage*: as you pay down the principal each month, equivalent room opens on the HELOC. You then draw from the HELOC, transfer the money to a dedicated non-registered investment account, and buy income-producing assets.

## The "income-producing" requirement

The CRA requires the investment to have a *reasonable expectation of generating income* for the interest to be deductible. In practice, an investment that makes taxable distributions, such as `$XEQT`, is easier to connect to an income-earning purpose.

Using the same HELOC for personal and investment spending can make part of the interest non-deductible and make the remaining deduction much harder to trace and defend.

## A worked example (fictional)

Imagine, with rounded illustrative numbers:

- A home purchased for $600,000 with 20% down, leaving a $480,000 mortgage.
- A 5-year fixed term at a comfortable rate, with a re-advanceable mortgage product.
- At renewal, the principal balance is roughly $400,000.

That has opened up approximately $80,000 of HELOC room. Borrowing the full $80,000 and investing it in `$XEQT` brings the household's total debt back to roughly $480,000 — the same as the original mortgage, but now split into two pieces:

```
[==========================================]   $480k Mortgage (non-deductible)

[====================================      ]   $400k Mortgage (non-deductible)
[                                    ======]    $80k HELOC    (potentially deductible)
```

Over time, more of the household’s debt is replaced by investment debt whose interest may be deductible, while the non-deductible mortgage balance shrinks.

## How much leverage are you actually taking on?

The deductibility framing can obscure the real risk. The Smith Manoeuvre is, mechanically, *leverage*. The honest question is: how leveraged am I against the portfolio I'm investing into?

A useful ratio is total invested assets divided by net invested capital:

- $400,000 portfolio, $100,000 of HELOC debt: $400,000 / ($400,000 − $100,000) = **1.33x leverage**.
- $200,000 portfolio, $100,000 of HELOC debt: $200,000 / ($200,000 − $100,000) = **2x leverage**.

The same $100,000 of HELOC debt is a very different risk profile against those two portfolios. The smaller the existing portfolio, the more aggressive the implicit leverage.

## What can go wrong

- A market drawdown is amplified against the borrowed dollars.
- HELOC rates are variable. Rising rates can coincide with falling markets, squeezing cash flow at the worst time.
- HELOCs are callable. The lender can demand repayment.
- Mingling personal and investment spending makes the debt harder to trace and can make part of the interest non-deductible.

A worthwhile mental check: if the portfolio dropped 50% tomorrow and rates doubled, would the household still be fine?

## Why it fits my philosophy

The Smith Manoeuvre fits because:

- I already prefer [leverage over concentration]({% link _notes/portfolio-foundations.md %}) as the way to take on additional risk.
- I expect a diversified equity portfolio to produce a higher long-term return than leaving additional equity in my home.
- The deductibility makes the leverage materially cheaper after tax.
- The investment side is `$XEQT`, which I'd want to own anyway.

It does not fit when the household is not yet [funding the basics]({% link _notes/canadian-tax-strategy.md %}#account-strategy), or when the leverage ratio against the existing portfolio is uncomfortably high.

## Related

- [Canadian Investing & Tax Strategy]({% link _notes/canadian-tax-strategy.md %})
- [Portfolio Foundations]({% link _notes/portfolio-foundations.md %})
