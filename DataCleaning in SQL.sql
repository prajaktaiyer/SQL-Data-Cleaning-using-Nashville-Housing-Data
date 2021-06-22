
/*Cleaning Data*/
SELECT * FROM NashvilleHousing
SELECT SaleDate from NashvilleHousing
--------------------------------------------------------------------------------------------------
--FORMAT DATE COLUMNS
SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing
--Begin Tran
--update NashvilleHousing set SaleDateConverted=CONVERT(Date,SaleDate)  
--rollback
--commit tran

--ALTER TABLE NashvilleHousing ADD SaleDateConverted Date
--------------------------------------------------------------------------------------------------
--Populate property address
SELECT PropertyAddress FROM NashvilleHousing

SELECT n1.ParcelID,n1.PropertyAddress,n2.ParcelID,n2.PropertyAddress, ISNULL(n1.PropertyAddress,n2.PropertyAddress)
FROM NashvilleHousing n1, NashvilleHousing n2
WHERE n1.ParcelID=n2.ParcelID AND n1.[UniqueID ] <> n2.[UniqueID ]
AND n1.PropertyAddress is null

--begin tran
--update n1
--set PropertyAddress= ISNULL(n1.PropertyAddress,n2.PropertyAddress)
--FROM NashvilleHousing n1, NashvilleHousing n2
--WHERE n1.ParcelID=n2.ParcelID AND n1.[UniqueID ] <> n2.[UniqueID ]
--AND n1.PropertyAddress is null
--commit

--------------------------------------------------------------------------------------
--Bringing propertyaddress to 1NF(atomic values)(Address,City,State)

SELECT PropertyAddress FROM NashvilleHousing
SELECT * from NashvilleHousing
SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM NashvilleHousing

--begin tran
--ALTER TABLE NashvilleHousing ADD PropertySplitAddress NVarchar(255)
--ALTER TABLE NashvilleHousing ADD PropertySplitCity NVarchar(255)
--commit
--rollback

--begin tran
--UPDATE NashvilleHousing SET PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
--UPDATE NashvilleHousing SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
--commit
--rollback

-------------------------------------------------------------------------------------
--SPLIT OWNER ADDRESS COLUMN into Street, City, State

SELECT * from NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

--begin tran
--ALTER TABLE NashvilleHousing ADD OwnerSplitAddress NVarchar(255)
--ALTER TABLE NashvilleHousing ADD OwnerSplitCity NVarchar(255)
--ALTER TABLE NashvilleHousing ADD OwnerSplitState NVarchar(255)
--commit
--rollback

--begin tran
--UPDATE NashvilleHousing SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
--UPDATE NashvilleHousing SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
--UPDATE NashvilleHousing SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
--commit
--rollback
------------------------------------------------------------------------------------------
--CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' COLUMN

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant ='N' THEN 'No'
	ELSE SoldAsVacant
END
FROM NashvilleHousing

--begin tran
--UPDATE NashvilleHousing
--SET SoldAsVacant = 
--CASE 
--	WHEN SoldAsVacant ='Y' THEN 'Yes'
--	WHEN SoldAsVacant ='N' THEN 'No'
--	ELSE SoldAsVacant
--END
--commit
--rollback

----------------------------------------------------------------------------------------------
--REMOVING DUPLICATES //dont delete data in practice//use temp tables or backups
--USING ROW_NUMBER() TO IDENTIFY ROWS

---TAKING BACKUP INTO NashvilleHousingduplicatesbkp
--WITH RowNumCTE AS
--(
--SELECT *,
--ROW_NUMBER() OVER(
--PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID 
--)row_num
--FROM NashvilleHousing
--)
--SELECT * into NashvilleHousingduplicatesbkp 
--from RowNumCTE
--WHERE row_num >1
--ORDER BY PropertyAddress

SELECT * FROM NashvilleHousingduplicatesbkp

--DELETING DUPLICATES
--begin tran

--WITH RowNumCTE AS
--(
--SELECT *,
--ROW_NUMBER() OVER(
--PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID 
--)row_num
--FROM NashvilleHousing
--)
--DELETE  
--from RowNumCTE
--WHERE row_num >1
--commit
--rollback


----------------------------------------------------------------------------------------------
--REMOVING UNUSED COLUMNS

SELECT * FROM NashvilleHousing

--begin tran
--ALTER TABLE NashvilleHousing
--DROP COLUMN OwnerAddress, PropertyAddress,SaleDate
--commit
--rollback

