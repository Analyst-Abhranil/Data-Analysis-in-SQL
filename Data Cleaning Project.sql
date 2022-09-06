select *
from Projects.dbo.Nashville_housing


--Standardize Date Format

select SaleDate
from Projects.dbo.Nashville_housing


alter table Nashville_housing
add converted_saledate date;

update Nashville_housing
set converted_saledate=convert(date,saledate)

select converted_saleDate
from Projects.dbo.Nashville_housing



--Populate Property Address Data

select *
from Projects.dbo.Nashville_housing
where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from Projects.dbo.Nashville_housing a
join Projects.dbo.Nashville_housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from Projects.dbo.Nashville_housing a
join Projects.dbo.Nashville_housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

select PropertyAddress
from Projects.dbo.Nashville_housing


--Breaking Address into Individual Columns(Address,City,State)

select substring(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1)as property_add,
substring(PropertyAddress,CHARINDEX(',',propertyAddress)+1,len(propertyAddress))as property_city
from Projects.dbo.Nashville_housing


alter table projects.dbo.Nashville_housing
add split_propertyaddress nvarchar(255);

update projects.dbo.Nashville_housing
set split_propertyaddress=substring(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1)

alter table projects.dbo.Nashville_housing
add split_propertycity nvarchar(255);

update projects.dbo.Nashville_housing
set split_propertycity=substring(PropertyAddress,CHARINDEX(',',propertyAddress)+1,len(propertyAddress));

select*
from Projects.dbo.nashville_housing

--Different method for owner address

select OwnerAddress, PARSENAME(replace(ownerAddress,',','.'),3),PARSENAME(replace(ownerAddress,',','.'),2),PARSENAME(replace(ownerAddress,',','.'),1)
from Projects.dbo.nashville_housing

alter table projects.dbo.Nashville_housing
add owner_address nvarchar(255);

update projects.dbo.Nashville_housing
set owner_address=PARSENAME(replace(ownerAddress,',','.'),3);


alter table projects.dbo.Nashville_housing
add owner_city nvarchar(255);

update projects.dbo.Nashville_housing
set owner_city=PARSENAME(replace(ownerAddress,',','.'),2);

alter table projects.dbo.Nashville_housing
add owner_state nvarchar(255);


update projects.dbo.Nashville_housing
set owner_state=PARSENAME(replace(ownerAddress,',','.'),1);

select owner_address,owner_city,owner_state
from Projects.dbo.nashville_housing



--Delete Duplicate rows

with RowNumCTE as
(
select*,
ROW_NUMBER() over (partition by parcelId,SaleDate,LegalReference,SalePrice,SaleDate
                   order by UniqueId)  row_nums
from Projects.dbo.nashville_housing
)

select *
from RowNumCTE
where row_nums>1
order by parcelId



with RowNumCTE as
(
select*,
ROW_NUMBER() over (partition by parcelId,SaleDate,LegalReference,SalePrice,SaleDate
                   order by UniqueId)  row_nums
from Projects.dbo.nashville_housing
)

Delete
from RowNumCTE
where row_nums>1
--order by parcelId




--Delete Unused Columns

select *
from Projects.dbo.nashville_housing

alter table Projects.dbo.nashville_housing
drop column SaleDate,PropertyAddress,OwnerAddress















