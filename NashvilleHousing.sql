
--cleaning data

select *
from Project1..NashvilleHousing

--standardize date format

select SaleDateConverted, convert(date,saledate)
from Project1..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,saledate)

alter table Nashvillehousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date,saledate)

--populate property address data

select *
from Project1..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Project1..NashvilleHousing a
join Project1..NashvilleHousing b
	on a.ParcelID = b. ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Project1..NashvilleHousing a
join Project1..NashvilleHousing b
	on a.ParcelID = b. ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual columns (address, city, state)

select PropertyAddress
from Project1..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from Project1..NashvilleHousing


alter table Nashvillehousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table Nashvillehousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select *
from Project1..NashvilleHousing




select OwnerAddress
from Project1..NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
from Project1..NashvilleHousing




alter table Nashvillehousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OWnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

alter table Nashvillehousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

alter table Nashvillehousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

select *
from Project1..NashvilleHousing





-- change Y and N to Yes and No in SoldAsVacant

select distinct (SoldAsVacant), count(SoldAsVacant)
from Project1..NashvilleHousing
group by SoldAsVacant
order by 2


select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
	   when soldasvacant ='N' then 'No'
	   else soldasvacant
	   end
from Project1..NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
	   when soldasvacant ='N' then 'No'
	   else soldasvacant
	   end



--remove duplicates

with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
					uniqueid
					) row_num

from Project1..NashvilleHousing

)
select *
from RowNumCTE
where row_num > 1
--order by propertyaddress

select *
from Project1..NashvilleHousing



--delete unused columns


select *
from Project1..NashvilleHousing

alter table Project1..NashvilleHousing
drop column OwnerAddress, Taxdistrict, PropertyAddress

alter table Project1..NashvilleHousing
drop column SaleDate