# MSSQL-DataSimilarityEngine

This project provides a full working example of how to find similar records in SQL Server using Euclidean distance. It includes dynamic pivoting, feature scaling, and distance computation for high-dimensional categorical and numerical data — all done with T-SQL procedures and temporary tables.

---

## 📌 Overview

The solution simulates a dataset, transforms categorical variables into one-hot encoded columns, normalizes all features, and finally computes pairwise Euclidean distances between records.

It’s a great foundation for:
- Duplicate detection
- Clustering preparation
- Similarity-based searches
- Fuzzy matching

---

## 🧪 Sample Workflow

The included script demonstrates the full pipeline:

1. **Data Generation**  
   Creates a sample table `#DataTable` with:
   - `CatVal`: Random categorical values (e.g., A, B, C…)
   - `DigitVal`, `DigitVal2`: Random numeric values

2. **Get Distinct Categories**  
   Uses `Transform.GetDistinctData` to dynamically extract distinct categorical values for pivoting.

3. **Dynamic Pivoting**  
   Transforms `CatVal` into one-hot encoded columns using `Transform.DynamicPivot`, saved in `#Pivot`.

4. **Feature Scaling**  
   Calls `Transform.TableScaling` to normalize all numeric features, storing the result in `#STP2`.

5. **Distance Calculation**  
   Executes `Transform.TableDistance` to compute all pairwise Euclidean distances between records based on scaled features, inserting results into `#DISTANCE`.

6. **Ranking Similar Records**  
   Uses `NTILE` to rank record pairs by distance deciles and selects the most similar group.

---

## 📄 Example Output

| S1Id | S2Id | Distance     |
|------|------|--------------|
| 43   | 39   | 0.0872321123 |
| ...  | ...  | ...          |

You can also query the source table using the IDs found in closest pairs for further inspection.

---

## 🔧 Stored Procedures Used

The project relies on stored procedures from a helper schema `Transform`:

- `Transform.GetDistinctData`
- `Transform.DynamicPivot`
- `Transform.TableScaling`
- `Transform.TableDistance`

If you need help implementing those helper procedures, feel free to open an issue.

---

## ▶️ How to Run

1. Open the provided SQL script in SSMS.
2. Execute all statements as-is. No database objects will be permanently created (only temporary tables).
3. Inspect the `#DISTANCE` table for similarity results.

---

## 📂 Files

- `sql-procedures/GetDistinctData.sql` — Extracts a distinct list of values from a specified column, used to support dynamic pivoting and schema generation.
- `sql-procedures/DynamicPivot.sql` — Dynamically pivots a categorical column into multiple binary (one-hot encoded) columns, useful for machine learning–like transformations in T-SQL.
- `sql-Functions/TableScaling.sql` — Scales numeric columns in a table to a 0–1 range using Min-Max normalization. Essential for unbiased distance calculation.
- `sql-Functions/TableDistance.sql` — Generates a dynamic SQL query to calculate pairwise Euclidean distances between records based on selected numeric features.

---

## 📜 License

This project is licensed under the MIT License.

---

## 👤 Author

Developed by Hamid Doostparvar
Feel free to contribute, suggest improvements, or report issues.
