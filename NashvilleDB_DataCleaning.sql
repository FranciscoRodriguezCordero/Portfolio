/*
Cleaning Data in SQL Queries
*/

SELECT * FROM NashvilleHousing 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM NashvilleHousing 

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE; 

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT NashvilleHousing.PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

--For Property Address using SUBSTRING function 

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS ADDRESS 
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255); 

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255); 

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT 
PropertySplitAddress
, PropertySplitCity
FROM NashvilleHousing


--For Owner Address using PARSENAME function 

SELECT 
OwnerSplitAddress
,OwnerSplitCity
,OwnerSplitState
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255); 

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255); 

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255); 

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
  END 
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END 

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY ParcelID,
PropertyAddress,
SaleDate,
LegalReference
ORDER BY 
UniqueID) row_num

FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT * FROM NashvilleHousing

ALTER TABLE  NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



