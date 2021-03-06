<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <pattern>
        <rule context="/">
            <assert test="exists(country-mission)">The document's root element must be country-mission</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="country-mission">
            <assert test="exists(territory-id)">Missing territory-id element</assert>
            <assert test="count(territory-id) le 1">Only one territory-id element allowed</assert>
            <assert test="exists(chiefs)">Missing chiefs element</assert>
            <assert test="count(chiefs) le 1">Only one chiefs element allowed</assert>
            <assert test="exists(other-nominees)">Missing other-nominees element</assert>
            <assert test="count(other-nominees) le 1">Only one other-nominees element
                allowed</assert>
            <assert test="exists(last-modified-by)">Missing last-modified-by element</assert>
            <assert test="count(last-modified-by) le 1">Only one last-modified-by element
                allowed</assert>
            <assert test="exists(last-modified-date)">Missing last-modified-date element</assert>
            <assert test="count(last-modified-date) le 1">Only one last-modified-date element
                allowed</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="country-mission/territory-id">
            <let name="basename" value="replace(base-uri(.), '^.*/(.*?)$', '$1')"/>
            <assert test="$basename = concat(., '.xml')">The id “<value-of select="."/>” does
                not match filename “<value-of select="$basename"/>”</assert>
            <assert test="matches(., '^[a-z-]+$')">The id 
                “<value-of select="."/>” must contain only lower case letters and hyphens</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="chief/id">
            <assert test="matches(., '^\w{2}-\d{4}-\w{1,4}-\d{2}$')">The id 
                “<value-of select="."/>” should take the form xx-dddd-xxxx-dd, where x is a lower case letter and d is a digit</assert>
            <let name="territory-id" value="root(.)/country-mission/territory-id"/>
            <let name="current-territory-iso" value="doc(concat('../../countries/data/', $territory-id, '.xml'))/country/iso2"/>
            <assert test="tokenize(., '-')[1] = $current-territory-iso">The first portion of the id should be the 2-letter ISO country code: <value-of select="$current-territory-iso"/></assert>
            <assert test="not(../date[. ne '']) or tokenize(., '-')[2] = substring(subsequence(..//date[. ne ''], 1, 1), 1, 4)">The second portion of the id should be the year portion of the first date in the record; or if no date, the year closest to the beginning of events described</assert>
            <assert test="tokenize(., '-')[3] = substring(tokenize(./following-sibling::person-id, '-')[1], 1, 4)">The third portion of the id should be the first four letters of the surname portion of a person's ID, e.g., “<value-of select="substring(tokenize(./following-sibling::person-id, '-')[1], 1, 4)"/>”</assert>
            <assert test="string-length(tokenize(., '-')[4]) = 2">The fourth portion of the id should be a two digit increment, starting 01 unless there's already a previous ID matching 01</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="chief">
            <assert test="exists(id)">Missing id element</assert>
            <assert test="count(id) le 1">Only one id element allowed</assert>
            <assert test="exists(person-id)">Missing person-id element</assert>
            <assert test="count(person-id) le 1">Only one person-id element allowed</assert>
            <assert test="exists(role-title-id)">Missing role-title-id element</assert>
            <assert test="count(role-title-id) le 1">Only one role-title-id element allowed</assert>
            <assert test="exists(contemporary-territory-id)">Missing contemporary-territory-id element</assert>
            <assert test="count(contemporary-territory-id) le 1">Only one contemporary-territory-id element allowed</assert>
            <assert test="exists(appointed)">Missing appointed element</assert>
            <assert test="count(appointed) le 1">Only one appointed element allowed</assert>
            <assert test="exists(started)">Missing started element</assert>
            <assert test="count(started) le 1">Only one started element allowed</assert>
            <assert test="exists(ended)">Missing ended element</assert>
            <assert test="count(ended) le 1">Only one ended element allowed</assert>
            <assert test="exists(note)">Missing note element</assert>
            <assert test="count(note) le 1">Only one note element allowed</assert>
            <assert test="exists(last-modified-by)">Missing last-modified-by element</assert>
            <assert test="count(last-modified-by) le 1">Only one last-modified-by element
                allowed</assert>
            <assert test="exists(last-modified-date)">Missing last-modified-date element</assert>
            <assert test="count(last-modified-date) le 1">Only one last-modified-date element
                allowed</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="chief//date[. ne ''][parent::*/preceding-sibling::*[1][date ne '']]">
            <assert test=". ge ./parent::*/preceding-sibling::*[date ne ''][1]/date">Date ordering problem. expected this date to come after the preceding date.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="person-id">
            <assert test="matches(., '^[a-z-]+\d?$')">The person-id “<value-of select="."/>” should only contain lower-case letters and hyphens, with an optional digit as the last character</assert>
            <assert test="doc-available(concat('../data/people/', substring(., 1, 1), '/', ., '.xml'))">The person-id “<value-of select="."/>” was not found in the people collection.</assert>
            <!--<assert test="doc(concat('http://localhost:8080/services/check-person-id?person-id=', .))/result/is-valid = 'true'">The person-id “<value-of select="."/>” was not found in the database.</assert>-->
        </rule>
    </pattern>
    <pattern>
        <rule context="contemporary-territory-id">
            <!-- NOTE: THIS PATH TO GSH ASSUMES THAT GSH APP IS THE SAME DIRECTORY AS PAHO-TRUNK -->
            <assert test="doc-available(concat('../../../../../../gsh/data/territories/', ., '.xml'))">The contemporary-territory-id “<value-of select="."/>” was not found in the gsh territory collection.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="date">
            <assert test="(. = '') or matches(., '^\d{4}$') or matches(., '^\d{4}-\d{2}$') or . castable as xs:date">Date should be yyyy-mm-dd, yyyy-mm, or empty</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="created-date | last-modified-date">
            <assert test=". castable as xs:date">Should be a valid date, yyyy-mm-dd</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="last-modified-date">
            <assert test="xs:date(.) ge xs:date(./preceding-sibling::created-date)">Last
                updated date should come after the created date</assert>
        </rule>
    </pattern>
</schema>
