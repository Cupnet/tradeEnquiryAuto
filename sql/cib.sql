SELECT 
    r.repo_id AS "Repo Id",
    r.company_code AS "Cpy",
    r.trade_description AS "Trade Description",
    DECODE(r.status, 'V', 'Unverified', 'U', 'Pending', 'X', 'Cancelled', 'O', 'Open', 'C', 'Closed') AS "Status", 
    r.profit_centre_mnemonic AS "Book",
    r.agency_fund AS "Agency Fund",
    r.client_code AS "Client Code",
    r.client_name AS "Client Name",
    r.agreement_description AS "Agreement",
    r.currency_code AS "Ccy",
    r.start_cash_value AS "Start Cash",
    r.end_cash_value AS "End Cash",
    r.trade_date AS "Trade Date",
    r.start_date AS "Start Date",
    r.end_date AS "End Date",
    r.parent_repo_id AS "Parent Repo",
    r.repo_rate_type AS "Rate Type",
    r.rate AS "Rate",
    r.display_stock_code AS "Stock Code",
    r.stock_name AS "Stock Name",
    r.stock_currency_code AS "Stock Ccy",
    r.external_id AS "External Ref",
    r.market_index_code AS "Market Index",
    r.spread AS "Spread (bps)",
    CASE 
        WHEN r.breakdown_status IS NOT NULL THEN 'Y' 
        ELSE NULL 
    END AS "Breakdown",
    r.novation_partner_code AS "Novation Partner Code",
    r.novation_status AS "Novation Status",
    r.novation_status_date AS "Novation Date",
    r.novation_user AS "Novation User",
    r.total_broker_fee AS "Total Broker Fee",
    r.collateral_cost AS "Collateral Cost",
    r.quantity AS "Quantity",
    r.collateral_rate_bps AS "Collateral Rate (bps)",
    r.final_maturity_date AS "Final Maturity Date", 
    r.callable_flag AS "Callable Flag",
    r.company_depot_code AS "Agent Code",
    r.display_xref1 AS "Trade Xref 1",
    r.display_xref_type1 AS "Trade Xref Type 1",
    r.display_xref2 AS "Trade Xref 2",
    r.display_xref_type2 AS "Trade Xref Type 2",
    r.display_xref3 AS "Trade Xref 3",
    r.display_xref_type3 AS "Trade Xref Type 3",
    r.display_xref4 AS "Trade Xref 4",
    r.display_xref_type4 AS "Trade Xref Type 4",
    r.display_xref5 AS "Trade Xref 5",
    r.display_xref_type5 AS "Trade Xref Type 5",
    r.display_xref6 AS "Trade Xref 6",
    r.display_xref_type6 AS "Trade Xref Type 6",
    r.agent_name AS "Agent Name",
    ar.narrative AS "External Narrative"
FROM al_vw_qs_repo r 
LEFT JOIN al_client_type ct 
    ON r.company_code = ct.company_code 
    AND r.client_type_code = ct.client_type_code
LEFT OUTER JOIN al_trade_xref tx 
    ON r.repo_id = tx.internal_ref 
    AND tx.internal_ref_type = 'R' 
    AND (('<All>' = '<All>' AND tx.default_xref = 'Y') 
    OR tx.trade_xref_type = '<All>' 
    OR tx.trade_xref = '<All>')
LEFT JOIN AL_REPO ar 
    ON r.repo_id = ar.repo_id
WHERE r.trade_type || r.repo_type IN (
    'SB', 'ML', 'MB', 'BL', 'BB', 'LL', 'LB', 'FL', 'FB', 'EL', 'EB', 'NL', 'NB'
) 
AND r.start_date <= (
    SELECT look_up_date 
    FROM al_system_code 
    WHERE system_code='CURRBUSDAY' 
    AND rownum=1
) --T
AND r.end_date >= (
    SELECT look_up_date 
    FROM al_system_code 
    WHERE system_code='NEXTBUSDAY' 
    AND rownum=1
)  --T+1
AND r.company_code = 'CIB'