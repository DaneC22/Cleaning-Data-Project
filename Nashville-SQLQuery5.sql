
SELECT *
INTO [Nashville_Housing_Backup]
FROM portfolioproject..[NashvilleHousing];


Create TABLE NashvilleHousing (
    UniqueID NVARCHAR(50),
    ParcelID NVARCHAR(50),
    LandUse NVARCHAR(100),
    PropertyAddress NVARCHAR(255),
    SaleDate DATE,
    SalePrice MONEY,
    LegalReference NVARCHAR(100),
    SoldAsVacant NVARCHAR(10),
    OwnerName NVARCHAR(255),  -- No truncation!
    OwnerAddress NVARCHAR(255),
    Acreage FLOAT,
    TaxDistrict NVARCHAR(100),
    LandValue MONEY,
    BuildingValue MONEY,
    TotalValue MONEY,
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT
);

select*
from portfolioproject..NashvilleHousing

-- I imported the table as csv, so i have to enclosed some columns in quotations so they will imported under one column. 
-- the query below is to remove the quotation.

UPDATE portfolioproject..NashvilleHousing
SET 
  PropertyAddress = REPLACE(PropertyAddress, '"', ''),
  OwnerName = REPLACE(OwnerName, '"', ''),
  OwnerAddress = REPLACE(OwnerAddress, '"', '');

-- I'm still learning, so when I imported the csv, it returns some empty cell instead of "NULL", 
-- and I think SQL read empty cells and Null differently, so to prevent further error in running query, i chose to turn the empty cells into a "NULL"
  UPDATE portfolioproject..[NashvilleHousing]
SET PropertyAddress = NULL
WHERE PropertyAddress = '';

UPDATE portfolioproject..[NashvilleHousing]
SET OwnerName = NULL
WHERE OwnerName = '';

UPDATE portfolioproject..[NashvilleHousing]
SET OwnerAddress = NULL
WHERE OwnerAddress = '';

UPDATE portfolioproject..[NashvilleHousing]
SET Acreage = NULL
WHERE Acreage = '';

UPDATE portfolioproject..[NashvilleHousing]
SET TaxDistrict = NULL
WHERE TaxDistrict = '';

UPDATE portfolioproject..[NashvilleHousing]
SET LandValue = NULL
WHERE LandValue = '';

UPDATE portfolioproject..[NashvilleHousing]
SET BuildingValue = NULL
WHERE BuildingValue = '';

UPDATE portfolioproject..[NashvilleHousing]
SET TotalValue = NULL
WHERE TotalValue = '';

UPDATE portfolioproject..[NashvilleHousing]
SET YearBuilt = NULL
WHERE YearBuilt = '';

UPDATE portfolioproject..[NashvilleHousing]
SET Bedrooms = NULL
WHERE Bedrooms = '';

UPDATE portfolioproject..[NashvilleHousing]
SET FullBath = NULL
WHERE FullBath = '';

UPDATE portfolioproject..[NashvilleHousing]
SET HalfBath = NULL
WHERE HalfBath= '';

-- start of real cleaning.

--Populate Property Address Data

Select *
from portfolioproject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a. propertyaddress, b.parcelid, b.PropertyAddress, ISNULL(a.propertyaddress, b.Propertyaddress)
from portfolioproject..NashvilleHousing a
Join portfolioproject..NashvilleHousing b
	on a.ParcelId = b.Parcelid 
	and a.[UniqueID ] <> b. [UniqueID ]
where a.propertyaddress is null

Update a
set PropertyAddress = ISNULL(a.propertyaddress, b.Propertyaddress)
from portfolioproject..NashvilleHousing a
Join portfolioproject..NashvilleHousing b
	on a.ParcelId = b.Parcelid 
	and a.[UniqueID ] <> b. [UniqueID ]
where a.propertyaddress is null

-- Breaking out address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

-- using substring and charcater index
-- for the column of PropertyAddress
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing

--For the column of OwnerAddress
-- using PARSEName instead substring

Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select ParseName(replace(OwnerAddress,',','.'),3),
ParseName(replace(OwnerAddress,',','.'),2),
ParseName(replace(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing
-- now adding the new column

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255), OwnerSplitCity Nvarchar(255), OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress = ParseName(replace(OwnerAddress,',','.'),3)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = ParseName(replace(OwnerAddress,',','.'),2)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState = ParseName(replace(OwnerAddress,',','.'),1)

Select*
From PortfolioProject..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant) , count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
	CASE when SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'NO'
		Else SoldAsVacant
		END
From PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'NO'
		Else SoldAsVacant
		END
-----------------------------------------------------------------

-- Remove Duplicates
With RowNumCTE As (
Select *, 
	ROW_NUMBER () OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
					UniqueID) row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
where row_num >1
-- order by PropertyAddress


-- Deleting Unused Columns

Select*
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


