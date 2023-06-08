
 /** IMPORT DATA FROM EXCEL**/
  
 IF OBJECT_ID('AgeOfMotherandAgeSpecificFertilityRate') IS NOT NULL DROP TABLE  AgeOfMotherandAgeSpecificFertilityRate /** This syntax drops table 'AgeOfMotherandAgeSpecificFertilityRate' when s is run)**/

CREATE TABLE AgeOfMotherandAgeSpecificFertilityRate 
		(Year SMALLINT, Age_of_mother_at_birth_Allages INT,	Age_of_mother_at_birth_Under20 INT,	Age_of_mother_at_birth_20to24 INT,	
		Age_of_mother_at_birth_25to29 INT, Age_of_mother_at_birth_30to34 INT, 	Age_of_mother_at_birth_35to39 INT,		
		Age_of_mother_at_birth_40andOver INT, Livebirths_per_1000women_in_agegroup_Allages DECIMAL(6,2),Livebirths_per_1000women_in_agegroup_Under20 DECIMAL (6,2), 
		Livebirths_per_1000women_in_agegroup_20to24 DECIMAL(6,2), Livebirths_per_1000women_in_agegroup_25to29 DECIMAL(6,2),	
		Livebirths_per_1000women_in_agegroup_30to34 DECIMAL(6,2),	Livebirths_per_1000women_in_agegroup_35to39 DECIMAL(6,2),	
		Livebirths_per_1000women_in_agegroup_40andOver DECIMAL(6,2))

BULK INSERT  AgeOfMotherandAgeSpecificFertilityRate 
FROM 'C:\Users\User\Desktop\Portfolio Project\Livebirths by age of mother and age specific fertility rate - PortfolioInSQL.csv'
WITH (FORMAT = 'CSV')

/** Create required Views**/

CREATE VIEW BirthFertilityRate AS
SELECT R.Year, R.Total_Fertility_Rate_TFR 
	  ,A.[Livebirths_per_1000women_in_agegroup_Allages]
      ,A.[Livebirths_per_1000women_in_agegroup_Under20]
      ,A.[Livebirths_per_1000women_in_agegroup_20to24]
      ,A.[Livebirths_per_1000women_in_agegroup_25to29]
      ,A.[Livebirths_per_1000women_in_agegroup_30to34]
      ,A.[Livebirths_per_1000women_in_agegroup_35to39]
      ,A.[Livebirths_per_1000women_in_agegroup_40andOver]
FROM [dbo].[RawKeyBirthStatisticsData] AS R INNER JOIN [dbo].[AgeOfMotherandAgeSpecificFertilityRate] AS A
ON R.Year = A.Year

CREATE VIEW NumberOfLiveBirthSByAgeOfMother AS
SELECT [Year]
      ,[Age_of_mother_at_birth_Allages]
      ,[Age_of_mother_at_birth_Under20]
      ,[Age_of_mother_at_birth_20to24]
      ,[Age_of_mother_at_birth_25to29]
      ,[Age_of_mother_at_birth_30to34]
      ,[Age_of_mother_at_birth_35to39]
      ,[Age_of_mother_at_birth_40andOver]
FROM [dbo].[AgeOfMotherandAgeSpecificFertilityRate]


/** IMPORT DATA FROM EXCEL**/

IF OBJECT_ID('[dbo].[RawKeyBirthStatisticsData]') IS NOT NULL DROP TABLE [dbo].[RawKeyBirthStatisticsData] /** This syntax drops table 'RawKeyBirthStatisticsData' when s is run)**/

CREATE TABLE RawKeyBirthStatisticsData (Year SMALLINT, Number_of_live_births_Total INT
      ,Number_of_live_births_Male INT
      ,Number_of_live_births_Female INT
      ,Number_of_live_births_Within_marriage_or_civil_partnership INT
      ,Number_of_live_births_Outside_marriage_or_civil_partnership INT
      ,Total_Fertility_Rate_TFR DECIMAL(4,2)
      ,General_Fertility_Rate_GFR_all_live_births_per_1_000_women_aged_15_to_44 DECIMAL(4,2)
      ,Crude_Birth_Rate_CBR_all_live_births_per_1_000_population_of_all_ages DECIMAL(4,2)
      ,Sex_ratio_live_male_births_per_1_000_live_female_births INT
      ,Percentage_of_live_births_outside_marriage DECIMAL(4,2)
      ,Standardised_mean_age_of_mother_at_childbirth_years DECIMAL(4,2)
      ,Live_births_within_marriage_per_1_000_married_women_aged_15_to_44 DECIMAL(6,3)
      ,Live_births_outside_marriage_per_1_000_unmarried_women_aged_15_to_44 DECIMAL(4,2)
      ,Number_of_maternities INT
      ,Number_of_stillbirths_Total INT
      ,Number_of_stillbirths_Male INT
      ,Number_of_stillbirths_Female INT
      ,[Number_of_stillbirths_Within_marriage_or_civil_partnership] INT
      ,[Number_of_stillbirths_Outside_marriage_or_civil_partnership] INT
      ,[Stillbirth_rate_stillbirths_per_1_000_live_births_and_stillbirths] DECIMAL(4,2))

BULK INSERT [dbo].[RawKeyBirthStatisticsData]
FROM 'C:\Users\User\Desktop\Portfolio Project\Key Birth Statistics - PortfolioInSQL.csv'
WITH (FORMAT = 'CSV') 

/** CRAETE VIEWS GROUPING YEAR INTO BIN OF 4**/

CREATE VIEW Birth_Data AS
SELECT 
  CASE
  WHEN YEAR < 1942 THEN '1938-1941'
  WHEN YEAR < 1946 THEN '1942-1945'
  WHEN YEAR < 1950 THEN '1946-1949'
  WHEN YEAR < 1954 THEN '1950-1953'
  WHEN YEAR < 1958 THEN '1954-1957'
  WHEN YEAR < 1962 THEN '1958-1961'
  WHEN YEAR < 1966 THEN '1962-1965'
  WHEN YEAR < 1970 THEN '1966-1969'
  WHEN YEAR < 1974 THEN '1970-1973'
  WHEN YEAR < 1978 THEN '1974-1977'
  WHEN YEAR < 1982 THEN '1978-1981'
  WHEN YEAR < 1986 THEN '1982-1985'
  WHEN YEAR < 1990 THEN '1986-1989'
  WHEN YEAR < 1994 THEN '1990-1993'
  WHEN YEAR < 1998 THEN '1994-1997'
  WHEN YEAR < 2002 THEN '1998-2001'
  WHEN YEAR < 2006 THEN '2002-2005'
  WHEN YEAR < 2010 THEN '2006-2009'
  WHEN YEAR < 20014 THEN '2010-2013'
  WHEN YEAR < 2018 THEN '2014-2017'
  ELSE '2018-2021'
  END
  AS Year, SUM([Number_of_live_births_Total]) as Number_of_live_births_Total, SUM([Number_of_live_births_Male]) AS Number_of_live_births_Male, 
			   SUM([Number_of_live_births_Female]) AS Number_of_live_births_Female,
         	   SUM([Number_of_live_births_Within_marriage_or_civil_partnership]) AS Number_of_live_births_Within_marriage_or_civil_partnership,
			   SUM([Number_of_live_births_Outside_marriage_or_civil_partnership]) AS Number_of_live_births_Outside_marriage_or_civil_partnership,
			   SUM([Number_of_maternities]) AS Number_of_maternities,
		       SUM([Number_of_stillbirths_Total]) AS Number_of_stillbirths_Total,
			   SUM([Number_of_stillbirths_Male]) AS Number_of_stillbirths_Male,
			   SUM([Number_of_stillbirths_Female]) AS Number_of_stillbirths_Female,
			   SUM([Number_of_stillbirths_Within_marriage_or_civil_partnership]) AS Number_of_stillbirths_Within_marriage_or_civil_partnership,
			   SUM([Number_of_stillbirths_Outside_marriage_or_civil_partnership]) AS Number_of_stillbirths_Outside_marriage_or_civil_partnership
  FROM [dbo].[RawKeyBirthStatisticsData]
  GROUP BY (CASE
  WHEN YEAR < 1942 THEN '1938-1941'
  WHEN YEAR < 1946 THEN '1942-1945'
  WHEN YEAR < 1950 THEN '1946-1949'
  WHEN YEAR < 1954 THEN '1950-1953'
  WHEN YEAR < 1958 THEN '1954-1957'
  WHEN YEAR < 1962 THEN '1958-1961'
  WHEN YEAR < 1966 THEN '1962-1965'
  WHEN YEAR < 1970 THEN '1966-1969'
  WHEN YEAR < 1974 THEN '1970-1973'
  WHEN YEAR < 1978 THEN '1974-1977'
  WHEN YEAR < 1982 THEN '1978-1981'
  WHEN YEAR < 1986 THEN '1982-1985'
  WHEN YEAR < 1990 THEN '1986-1989'
  WHEN YEAR < 1994 THEN '1990-1993'
  WHEN YEAR < 1998 THEN '1994-1997'
  WHEN YEAR < 2002 THEN '1998-2001'
  WHEN YEAR < 2006 THEN '2002-2005'
  WHEN YEAR < 2010 THEN '2006-2009'
  WHEN YEAR < 20014 THEN '2010-2013'
  WHEN YEAR < 2018 THEN '2014-2017'
  ELSE '2018-2021'
  END)
 

  CREATE VIEW BirthRateData AS
  SELECT CASE
  WHEN YEAR < 1942 THEN '1938-1941'
  WHEN YEAR < 1946 THEN '1942-1945'
  WHEN YEAR < 1950 THEN '1946-1949'
  WHEN YEAR < 1954 THEN '1950-1953'
  WHEN YEAR < 1958 THEN '1954-1957'
  WHEN YEAR < 1962 THEN '1958-1961'
  WHEN YEAR < 1966 THEN '1962-1965'
  WHEN YEAR < 1970 THEN '1966-1969'
  WHEN YEAR < 1974 THEN '1970-1973'
  WHEN YEAR < 1978 THEN '1974-1977'
  WHEN YEAR < 1982 THEN '1978-1981'
  WHEN YEAR < 1986 THEN '1982-1985'
  WHEN YEAR < 1990 THEN '1986-1989'
  WHEN YEAR < 1994 THEN '1990-1993'
  WHEN YEAR < 1998 THEN '1994-1997'
  WHEN YEAR < 2002 THEN '1998-2001'
  WHEN YEAR < 2006 THEN '2002-2005'
  WHEN YEAR < 2010 THEN '2006-2009'
  WHEN YEAR < 20014 THEN '2010-2013'
  WHEN YEAR < 2018 THEN '2014-2017'
  ELSE '2018-2021'
  END AS Year
      ,AVG([Total_Fertility_Rate_TFR]) AS Total_Fertility_Rate_TFR
      ,AVG([General_Fertility_Rate_GFR_all_live_births_per_1_000_women_aged_15_to_44]) AS General_Fertility_Rate_GFR_all_live_births_per_1_000_women_aged_15_to_44
      ,AVG([Crude_Birth_Rate_CBR_all_live_births_per_1_000_population_of_all_ages]) AS Crude_Birth_Rate_CBR_all_live_births_per_1_000_population_of_all_ages
      ,AVG([Percentage_of_live_births_outside_marriage]) AS Percentage_of_live_births_outside_marriage
      ,AVG([Standardised_mean_age_of_mother_at_childbirth_years]) AS Standardised_mean_age_of_mother_at_childbirth_years
	  ,AVG([Live_births_within_marriage_per_1_000_married_women_aged_15_to_44]) AS Live_births_within_marriage_per_1_000_married_women_aged_15_to_44
      ,AVG([Live_births_outside_marriage_per_1_000_unmarried_women_aged_15_to_44]) AS Live_births_outside_marriage_per_1_000_unmarried_women_aged_15_to_44
      ,AVG([Stillbirth_rate_stillbirths_per_1_000_live_births_and_stillbirths]) AS Stillbirth_rate_stillbirths_per_1_000_live_births_and_stillbirths
FROM [dbo].[RawKeyBirthStatisticsData]
GROUP BY CASE
  WHEN YEAR < 1942 THEN '1938-1941'
  WHEN YEAR < 1946 THEN '1942-1945'
  WHEN YEAR < 1950 THEN '1946-1949'
  WHEN YEAR < 1954 THEN '1950-1953'
  WHEN YEAR < 1958 THEN '1954-1957'
  WHEN YEAR < 1962 THEN '1958-1961'
  WHEN YEAR < 1966 THEN '1962-1965'
  WHEN YEAR < 1970 THEN '1966-1969'
  WHEN YEAR < 1974 THEN '1970-1973'
  WHEN YEAR < 1978 THEN '1974-1977'
  WHEN YEAR < 1982 THEN '1978-1981'
  WHEN YEAR < 1986 THEN '1982-1985'
  WHEN YEAR < 1990 THEN '1986-1989'
  WHEN YEAR < 1994 THEN '1990-1993'
  WHEN YEAR < 1998 THEN '1994-1997'
  WHEN YEAR < 2002 THEN '1998-2001'
  WHEN YEAR < 2006 THEN '2002-2005'
  WHEN YEAR < 2010 THEN '2006-2009'
  WHEN YEAR < 20014 THEN '2010-2013'
  WHEN YEAR < 2018 THEN '2014-2017'
  ELSE '2018-2021'
  END

 