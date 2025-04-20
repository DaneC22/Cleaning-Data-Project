# Nashville Housing Data Cleaning with SQL

This project showcases a comprehensive data cleaning process using SQL, specifically applied to the **Nashville Housing dataset**. The goal was to clean, standardize, and prepare the data for analysis by removing inconsistencies, formatting issues, and irrelevant information.

---

##  Tools Used

- SQL Server Management Studio (SSMS)
- Microsoft SQL Server
- CSV import
- Manual cleaning via SQL queries

---

##  Project Steps

### 1.  Backup and Table Creation
- Created a backup table `Nashville_Housing_Backup`.
- Defined a clean table schema with appropriate data types and field lengths.

### 2.  Initial Cleanup
- Removed unnecessary quotation marks from fields (`PropertyAddress`, `OwnerName`, `OwnerAddress`).
- Replaced empty strings with `NULL` to ensure proper handling of missing data.

### 3.  Address Data Enhancement
- Populated missing `PropertyAddress` values by joining on `ParcelID`.
- Split the `PropertyAddress` into `PropertySplitAddress` and `PropertySplitCity`.
- Used `PARSEName()` to split `OwnerAddress` into `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState`.

### 4.  Categorical Data Cleaning
- Cleaned the `SoldAsVacant` field by converting `'Y'` and `'N'` to `Yes` and `No`.

### 5.  Duplicate Removal
- Identified and removed duplicate records using `ROW_NUMBER()` within a CTE.

### 6.  Dropping Unused Columns
- Dropped irrelevant or redundant columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`) to declutter the dataset.

---

## Skills Demonstrated

- Data wrangling with SQL
- Using `SUBSTRING()`, `CHARINDEX()`, `PARSEName()` for string manipulation
- Handling `NULL` vs. empty values
- Data deduplication using CTEs and `ROW_NUMBER()`
- Best practices for data preprocessing

---

## 📁 Dataset

The dataset used in this project is the **Nashville Housing data**, from Alex the Analyst Youtube video.

---

## Notes

- This project is part of my learning journey in data analytics and SQL. Feedback and suggestions are welcome!
- All transformations were done in SQL to simulate real-world backend data preparation workflows.

---

## Connect With Me

If you're interested in data analysis, SQL, or collaborating on similar projects, feel free to reach out or explore my https://github.com/DaneC22.

