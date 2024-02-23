-- Data cleaning SaleDate

Select*
from [Natavasille cleaning]

Select SaleDateConverted, CONVERT(date,SaleDate)
from [Natavasille cleaning]

Update [Natavasille cleaning]
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE [Natavasille cleaning]
Add SaleDateConverted date

Update [Natavasille cleaning]
SET SaleDateConverted = CONVERT(date,SaleDate)

-- Populate Property Address data

Select *
from [Natavasille cleaning]
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Natavasille cleaning] a
 JOIN [Natavasille cleaning] b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]

 Update a
 SET PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
 from [Natavasille cleaning] a
 JOIN [Natavasille cleaning] b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 

 --Breaking out Addresss into columns (Address, city, State)

 select*
 from [Natavasille cleaning]

 Select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) AS Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) As Address

 from [Natavasille cleaning]


 ALTER TABLE [Natavasille cleaning]
Add PropertySplitAddress Nvarchar(255);

Update [Natavasille cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) 


 ALTER TABLE [Natavasille cleaning]
Add PropertySplitCity Nvarchar(255);

Update [Natavasille cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select OwnerAddress
from [Natavasille cleaning]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from [Natavasille cleaning]


ALTER TABLE [Natavasille cleaning]
Add  OwnerSplitAddress nvarchar(255)

Update [Natavasille cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE [Natavasille cleaning]
Add  OwnerSplitCity nvarchar(255)

Update [Natavasille cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE [Natavasille cleaning]
Add  OwnerSplitState nvarchar(255)

Update [Natavasille cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select*
from [Natavasille cleaning]


-- Change Y and N to Yes and No in Sold as Vacant

select distinct(SoldAsVacant), COUNT(soldasvacant)
from [Natavasille cleaning]
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
CASE When Soldasvacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
END
from [Natavasille cleaning]


Update [Natavasille cleaning]
SET SoldasVacant = CASE When Soldasvacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
END


--Remove Duplicates

with RowCTE as (
Select*, 
Row_number() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY UniqueID
		) row_num
		
from [Natavasille cleaning]
) 
--order by ParcelID

DELETE
from RowCTE
where row_num > 1
--Order by PropertyAddress


-- Delete Unused Column
select*
from [Natavasille cleaning]


ALTER TABLE [Natavasille cleaning]
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

ALTER TABLE [Natavasille cleaning]
DROP COLUMN SaleDate

ALTER TABLE [Natavasille cleaning]
DROP COLUMN SaleDate