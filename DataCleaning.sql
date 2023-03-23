---------------------------------------------------------------------------------
--Cleaning Data in SQL queries

select * from PortfolioProject..NashvilleHousing;

---------------------------------------------------------------------------------
--Standarize Data format

select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

---------------------------------------------------------------------------------
-- Populate Property Address Data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

---------------------------------------------------------------------------------
--Breaking out address into individual columns(Address, city, State)

select * 
from PortfolioProject..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing

ALTER table NashvilleHousing
add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER table NashvilleHousing
add PropertySplitCity nvarchar(255)

Update NashvilleHousing
set PropertySplitCity = Substring(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


select * 
from PortfolioProject..NashvilleHousing


select 
Parsename(replace(OwnerAddress, ',','.'),3),
Parsename(replace(OwnerAddress, ',','.'),2),
Parsename(replace(OwnerAddress, ',','.'),1)
from PortfolioProject..NashvilleHousing

ALTER table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = Parsename(replace(OwnerAddress, ',','.'),3)

ALTER table NashvilleHousing
add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
set OwnerSplitCity = Parsename(replace(OwnerAddress, ',','.'),2)

ALTER table NashvilleHousing
add OwnerSplitState nvarchar(255)

Update NashvilleHousing
set OwnerSplitState = Parsename(replace(OwnerAddress, ',','.'),1)
----------------------------------------------------------------------------------------------------------
--Change Y and N to yes and no in "sold as vacant" field

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 End
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 End
----------------------------------------------------------------------------------------------------------
--Delete Unused Columns

select * 
from PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table PortfolioProject..NashvilleHousing
Drop column SaleDate