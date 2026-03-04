-- Prescribers Database
-- For this exericse, you'll be working with a database derived from the Medicare Part D Prescriber Public Use File. More information about the data is contained in the Methodology PDF file. See also the included entity-relationship diagram.




-- 1a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- in the 'prescription' table, look at 'npi' and 'total_calim_count'
-- group by npi, since each row is a event

SELECT npi, COUNT(drug_name) as total_drug, SUM(total_claim_count) as total_claim
FROM public.prescription
GROUP BY npi
ORDER BY SUM(total_claim_count) DESC
LIMIT 5;

--**answer: the higherst prescriber is npi #1881634483 with 99707 total claims


-- 1b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

-- merge table prescriber with prescription on 'npi'

SELECT
	ps.NPI,
	pr.NPPES_PROVIDER_FIRST_NAME,
	pr.NPPES_PROVIDER_LAST_ORG_NAME,
	pr.SPECIALTY_DESCRIPTION,
	SUM(ps.TOTAL_CLAIM_COUNT)
FROM
	PRESCRIPTION as ps
LEFT JOIN PRESCRIBER as pr ON PS.NPI = PR.NPI
GROUP BY
	ps.NPI,
	pr.NPPES_PROVIDER_FIRST_NAME,
	pr.NPPES_PROVIDER_LAST_ORG_NAME,
	pr.SPECIALTY_DESCRIPTION
ORDER BY
	SUM(ps.TOTAL_CLAIM_COUNT) DESC
LIMIT
	5;

-- 2a. Which specialty had the most total number of claims (totaled over all drugs)?
-- same process as 1b but group by specialty description 
SELECT
	pr.SPECIALTY_DESCRIPTION,
	SUM(ps.TOTAL_CLAIM_COUNT) as total_claim_count
FROM
	PRESCRIPTION as ps
LEFT JOIN PRESCRIBER as pr ON PS.NPI = PR.NPI
GROUP BY
	pr.SPECIALTY_DESCRIPTION
ORDER BY
	SUM(ps.TOTAL_CLAIM_COUNT) DESC
LIMIT
	5;
--** answer: family practice has highest presentions with 9752347

-- 2b. Which specialty had the most total number of claims for opioids?
-- do two different joins 
SELECT
	PR.SPECIALTY_DESCRIPTION,
	DR.OPIOID_DRUG_FLAG,
	SUM(PS.TOTAL_CLAIM_COUNT) AS TOTAL_CLAIM_COUNT
FROM
	PRESCRIPTION AS PS
	LEFT JOIN PRESCRIBER AS PR ON PS.NPI = PR.NPI
	LEFT JOIN DRUG AS DR ON PS.DRUG_NAME = DR.DRUG_NAME
--WHERE DR.OPIOID_DRUG_FLAG = Y ## no idea why this isnt working 
GROUP BY
	PR.SPECIALTY_DESCRIPTION,
	DR.OPIOID_DRUG_FLAG
ORDER BY
	SUM(PS.TOTAL_CLAIM_COUNT) DESC,
	DR.OPIOID_DRUG_FLAG;


-- 2c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
-- 2d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?
-- 3a. Which drug (generic_name) had the highest total drug cost?
-- 3b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
-- 4a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. Hint: You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/
-- 4b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
-- 5a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
-- 5b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
-- 5c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
-- 6a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
-- 6b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- 6c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- 7 The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.
-- 7a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.
-- 7b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
-- 7c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.