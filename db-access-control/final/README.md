# Activity 4 Project Tests

[Progress report](../../docs/Activity4-Progress-Report-Casilan-de-Guzman.pdf)

Each group folder contains its setup notes, account roles, SQL and test results. The full verification table is in verification-results.csv.

HealthBridge is G04, SHIORI is G05 and UniSync is G10. Repository and database names sometimes use different numbers.

The shared-tests folder contains the combined permission and application suites for G04, G05, G06 and G08. The original result order is retained for the verification table.

SQL labeled reconstructed was prepared from the existing configuration. It is not an original execution log and does not recreate ownership, function grants or default privileges by itself. Follow REPRODUCE.md and the source setup scripts. Catalog audits and WHERE false statements do not prove that rows were changed.

G01/G03 remain incomplete for this activity. Their original restricted-account output was unavailable, and their runtime privilege groups and isolation still need work. The older SHIORI source review is retained for reference; the later PostgreSQL tests are the current result.

Delivered feedback and dates are listed in feedback-sent.md. Activity 5 and 6 feedback remains separate.
