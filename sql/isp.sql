SELECT 
    r.repo_id AS "Repo Id_2",
    r.company_code AS "Cpy_2",
    r.trade_description AS "Trade Description_2",
    DECODE(r.status, 'V', 'Unverified', 'U', 'Pending', 'X', 'Cancelled', 'O', 'Open', 'C', 'Closed') AS "Status_2", 
    r.profit_centre_mnemonic AS "Book_2",
    r.agency_fund AS "Agency Fund_2",
    r.client_code AS "Client Code_2",
    r.client_name AS "Client Name_2",
    r.agreement_description AS "Agreement_2",
    r.currency_code AS "Ccy_2",
    r.start_cash_value AS "Start Cash_2",
    r.end_cash_value AS "End Cash_2",
    r.trade_date AS "Trade Date_2",
    r.start_date AS "Start Date_2",
    r.end_date AS "End Date_2",
    r.parent_repo_id AS "Parent Repo_2",
    r.repo_rate_type AS "Rate Type_2",
    r.rate AS "Rate_2",
    r.display_stock_code AS "Stock Code_2",
    r.stock_name AS "Stock Name_2",
    r.stock_currency_code AS "Stock Ccy_2",
    r.external_id AS "External Ref_2",
    r.market_index_code AS "Market Index_2",
    r.spread AS "Spread (bps)_2",
    CASE 
        WHEN r.breakdown_status IS NOT NULL THEN 'Y' 
        ELSE NULL 
    END AS "Breakdown_2",
    r.novation_partner_code AS "Novation Partner Code_2",
    r.novation_status AS "Novation Status_2",
    r.novation_status_date AS "Novation Date_2",
    r.novation_user AS "Novation User_2",
    r.total_broker_fee AS "Total Broker Fee_2",
    r.collateral_cost AS "Collateral Cost_2",
    r.quantity AS "Quantity_2",
    r.collateral_rate_bps AS "Collateral Rate (bps)_2",
    r.final_maturity_date AS "Final Maturity Date_2", 
    r.callable_flag AS "Callable Flag_2",
    r.company_depot_code AS "Agent Code_2",
    r.display_xref1 AS "Trade Xref 1_2",
    r.display_xref_type1 AS "Trade Xref Type 1_2",
    r.display_xref2 AS "Trade Xref 2_2",
    r.display_xref_type2 AS "Trade Xref Type 2_2",
    r.display_xref3 AS "Trade Xref 3_2",
    r.display_xref_type3 AS "Trade Xref Type 3_2",
    r.display_xref4 AS "Trade Xref 4_2",
    r.display_xref_type4 AS "Trade Xref Type 4_2",
    r.display_xref5 AS "Trade Xref 5_2",
    r.display_xref_type5 AS "Trade Xref Type 5_2",
    r.display_xref6 AS "Trade Xref 6_2",
    r.display_xref_type6 AS "Trade Xref Type 6_2",
    r.agent_name AS "Agent Name_2",
    ar.narrative AS "External Narrative_2"
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
AND r.company_code = 'ISP'