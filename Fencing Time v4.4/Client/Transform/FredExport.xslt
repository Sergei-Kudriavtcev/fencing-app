<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<!-- Tournament export for AskFRED Version 5.0 data -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.askfred.net" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" encoding="UTF-8" />
  <xsl:variable name="fileVersion">4.4</xsl:variable>

  <!-- Mapping definitions -->
  <xsl:key name="ClubsByID"   match="/ft:FencingTimeData/ft:ExternalDatabase/ft:ArrayOfClub/ft:Club" use="@id" />
  <xsl:key name="FencersByID" match="/ft:FencingTimeData/ft:ExternalDatabase/ft:ArrayOfFencer/ft:Fencer" use="@id" />

  <!-- Main template matching rule -->
  <xsl:template match="/ft:FencingTimeData">
    <FencingData Version="5.0" Context="Results" Source="FTv{@ftversion}">
      <xsl:for-each select="ft:Tournament">
        <xsl:call-template name="ConvertTournament" />
      </xsl:for-each>
      <xsl:call-template name="ConvertDatabases" />
    </FencingData>
  </xsl:template>

  <!-- Create fencer, club, and team databases -->
  <xsl:template name="ConvertDatabases">
    <ClubDatabase>
      <Club ClubID="1" Name="Unattached (or Unknown)" Abbreviation="UNAT" City="" State="" DivisionID="69" />
      <xsl:for-each select="ft:ExternalDatabase/ft:ArrayOfClub/ft:Club">
        <xsl:call-template name="ConvertClub" />
      </xsl:for-each>
    </ClubDatabase>
    <FencerDatabase>
      <xsl:for-each select="ft:ExternalDatabase/ft:ArrayOfFencer/ft:Fencer">
        <xsl:call-template name="ConvertFencer" />
      </xsl:for-each>
    </FencerDatabase>
    <TeamDatabase>
      <xsl:for-each select="ft:Tournament/ft:ArrayOfEvent/ft:Event[@type='team']/ft:ArrayOfCompetitor/ft:Competitor">
        <xsl:call-template name="ConvertTeam" />
      </xsl:for-each>
    </TeamDatabase>
    <PointListDatabase />
    <RefereeDatabase />
  </xsl:template>

  <!-- Club entry template -->
  <xsl:template name="ConvertClub">
    <Club ClubID="{ft:FredID}"  Name="{ft:Name}" Abbreviation="{substring(ft:Abbreviation,1,10)}" City="{ft:Location}" State="">
      <xsl:attribute name="DivisionID">
        <xsl:call-template name="DivAbbrToFred">
          <xsl:with-param name="divAbbr" select="ft:Division" />
          <xsl:with-param name="natAbbr" select="ft:Country" />
        </xsl:call-template>
      </xsl:attribute>

      <xsl:if test="ft:MemberNum != '' and ft:Country = 'USA'">
        <Membership Org="USFA">
          <xsl:value-of select="ft:MemberNum" />
        </Membership>
      </xsl:if>
    </Club>
  </xsl:template>

  <!-- Fencer entry template -->
  <xsl:template name="ConvertFencer">
    <Fencer FencerID="{ft:FredID}" Gender="{ft:Gender}" FirstName="{ft:FirstName}" LastName="{ft:LastName}" 
            MiddleName="{ft:MiddleName}" NickName="{ft:Nickname}" Suffix="{ft:Suffix}">
      <xsl:attribute name="BirthYear">
        <xsl:choose>
          <xsl:when test="string-length(ft:BirthDate) &gt; 4">
            <xsl:value-of select="substring(ft:BirthDate, 1, 4)" />
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    
      <xsl:attribute name="ClubID1">
        <xsl:if test="ft:Club1 = '0'">1</xsl:if>
        <xsl:if test="ft:Club1 != '0'">
          <xsl:value-of select="key('ClubsByID', ft:Club1)/ft:FredID" />
        </xsl:if>
      </xsl:attribute>

      <xsl:if test="ft:Club2 != '0'">
        <xsl:attribute name="ClubID2">
          <xsl:value-of select="key('ClubsByID', ft:Club2)/ft:FredID" />
        </xsl:attribute>
      </xsl:if>

      <xsl:attribute name="DivisionID">
        <xsl:call-template name="DivAbbrToFred">
          <xsl:with-param name="divAbbr" select="ft:Division"/>
          <xsl:with-param name="natAbbr" select="ft:Country"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:for-each select="ft:ArrayOfMembership/ft:Membership">
        <Membership Org="{@authority}">
          <xsl:if test="string-length(@expirationDate) != 0">
            <xsl:attribute name="Expires">
              <xsl:value-of select="substring-before(@expirationDate, 'T')" />
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="." />
        </Membership>
      </xsl:for-each>

      <xsl:for-each select="ft:ArrayOfWeaponRating/ft:WeaponRating">
        <Rating Org="{@authority}" Weapon="{@weapon}">
          <xsl:call-template name="ConvertRating">
            <xsl:with-param name="rating" select="." />
          </xsl:call-template>
        </Rating>
      </xsl:for-each>
    </Fencer>
  </xsl:template>

  <!-- Team entry template -->
  <xsl:template name="ConvertTeam">
    <Team>
      <xsl:attribute name="TeamID">
        <xsl:value-of select="ft:TeamExternalID" />
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="ft:TeamName" />
      </xsl:attribute>
      <xsl:attribute name="TeamPoints">
        <xsl:value-of select="ft:TeamPoints" />
      </xsl:attribute>
      <xsl:attribute name="Captain">
        <xsl:value-of select="ft:TeamCaptain" />
      </xsl:attribute>
      <xsl:attribute name="DivisionID">
        <xsl:call-template name="DivAbbrToFred">
          <xsl:with-param name="divAbbr" select="ft:Division"/>
          <xsl:with-param name="natAbbr" select="ft:Country" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="ClubID">
        <xsl:if test="ft:TeamClubID = '0'">1</xsl:if>
        <xsl:if test="ft:TeamClubID != '0'">
          <xsl:value-of select="key('ClubsByID', ft:TeamClubID)/ft:FredID" />
        </xsl:if>
      </xsl:attribute>
      <xsl:for-each select="ft:ArrayOfEventFencer/ft:EventFencer">
        <Fencer FencerID="{key('FencersByID', @id)/ft:FredID}" />
      </xsl:for-each>
    </Team>
  </xsl:template>
    
  <!-- Tournament template -->
  <xsl:template name="ConvertTournament">
    <Tournament TournamentID="{ft:ExternalID}" Name="{ft:Name}" Location="{ft:Location}" Org="{ft:Authority}"
                StartDate="{substring-before(ft:StartDate, 'T')}" EndDate="{substring-before(ft:EndDate, 'T')}">

      <!-- Add events -->
      <xsl:for-each select="ft:ArrayOfEvent/ft:Event">
        <xsl:if test="ft:ArrayOfRound/ft:Round[@type='Results']">
          <Event EventID="{ft:ExternalID}" Description="" Weapon="{ft:Weapon}" Entries="{count(ft:ArrayOfCompetitor/ft:Competitor[ft:CheckInState='CheckedIn'])}">
            <xsl:attribute name="Gender">
              <xsl:call-template name="ConvertGender">
                <xsl:with-param name="gen" select="ft:GenderMix" />
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="AgeLimitMin">
              <xsl:call-template name="ConvertAgeLimit">
                <xsl:with-param name="age" select="ft:AgeLimit" />
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="AgeLimitMax">
              <xsl:call-template name="ConvertAgeLimit">
                <xsl:with-param name="age" select="ft:AgeLimit" />
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="RatingLimit">
              <xsl:call-template name="ConvertLevel">
                <xsl:with-param name="lev" select="ft:Level" />
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="Rating">
              <xsl:call-template name="ConvertEventClass">
                <xsl:with-param name="ec" select="ft:ArrayOfRound/ft:Round[@type='Results']/ft:ResultsRound/ft:EventClass" />
              </xsl:call-template>
            </xsl:attribute>

            <!-- Convert ind/team-specific stuff -->
            <xsl:if test="@type='ind'">
              <xsl:call-template name="ConvertIndEvent" />
            </xsl:if>
            <xsl:if test="@type='team'">
              <xsl:call-template name="ConvertTeamEvent" />
            </xsl:if>

            <xsl:call-template name="ConvertRoundResults" />
          </Event>
        </xsl:if>
      </xsl:for-each>
    </Tournament>
  </xsl:template>

  <!-- Individual event data template -->
  <xsl:template name="ConvertIndEvent">
    <xsl:attribute name="IsTeam">False</xsl:attribute>
    
    <FinalResults>
      <xsl:variable name="numComps" select="count(ft:ArrayOfRound/ft:Round[last()]/ft:ArrayOfRoundSeed/ft:RoundSeed[@actual])" />
      <xsl:for-each select="ft:ArrayOfRound/ft:Round[last()]/ft:ArrayOfRoundSeed/ft:RoundSeed[@actual]">
        <xsl:variable name="cid" select="@cid" />
        <xsl:variable name="evFencer" select="../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$cid]/ft:ArrayOfEventFencer/ft:EventFencer[1]" />

        <Result CompetitorID="{key('FencersByID', $evFencer/@id)/ft:FredID}">
          <xsl:attribute name="ClubID">
            <xsl:if test="$evFencer/ft:Club1ID = '0'">1</xsl:if>
            <xsl:if test="$evFencer/ft:Club1ID != '0'">
              <xsl:value-of select="key('ClubsByID', $evFencer/ft:Club1ID)/ft:FredID" />
            </xsl:if>
          </xsl:attribute>
          
          <xsl:attribute name="Excluded">
            <xsl:choose>
              <xsl:when test="../../..//ft:WDXCompetitor[@cid=$cid and @reason='Exclude']">True</xsl:when>
              <xsl:otherwise>False</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          
          <xsl:attribute name="Place">
            <xsl:call-template name="ConvertSeedValue">
              <xsl:with-param name="seed" select="@actual" />
              <xsl:with-param name="numComps" select="$numComps" />
            </xsl:call-template>
          </xsl:attribute>
          
          <xsl:attribute name="DNF">
            <xsl:call-template name="ConvertDNF">
              <xsl:with-param name="seed" select="." />
            </xsl:call-template>
          </xsl:attribute>
          
          <xsl:attribute name="RatingThen">
            <xsl:variable name="r">
              <xsl:call-template name="ConvertRating">
                <xsl:with-param name="rating" select="$evFencer/ft:WeaponRating" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$r = ''">U</xsl:if>
            <xsl:if test="$r != ''"><xsl:value-of select="$r"/></xsl:if>
          </xsl:attribute>

          <xsl:attribute name="RatingEarned">
            <xsl:variable name="r">
              <xsl:call-template name="ConvertRating">
                <xsl:with-param name="rating" select="../../ft:ResultsRound/ft:ArrayOfEarnedRating/ft:EarnedRating[@cid=$cid]" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$r != 'U'"><xsl:value-of select="$r"/></xsl:if>
          </xsl:attribute>
        </Result>
      </xsl:for-each>
    </FinalResults>
    
    <xsl:if test="ft:QualRuleID != '0'">
      <Qualifiers>
        <xsl:for-each select="ft:ArrayOfRound/ft:Round[last()]/ft:ResultsRound/ft:ArrayOfQualification/ft:Qualification">
          <xsl:variable name="cid" select="@cid" />
          <xsl:variable name="evFencer" select="../../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$cid]/ft:ArrayOfEventFencer/ft:EventFencer[1]" />
          
          <xsl:call-template name="AddQuals">
            <xsl:with-param name="pow2" select="1" />
            <xsl:with-param name="value" select="." />
            <xsl:with-param name="compID" select="key('FencersByID', $evFencer/@id)/ft:FredID" />
          </xsl:call-template>
        </xsl:for-each>
      </Qualifiers>
    </xsl:if>
  </xsl:template>

  <!-- Team event data template -->
  <xsl:template name="ConvertTeamEvent">
    <xsl:attribute name="IsTeam">True</xsl:attribute>
    
    <FinalResults>
      <xsl:variable name="numComps" select="count(ft:ArrayOfRound/ft:Round[last()]/ft:ArrayOfRoundSeed/ft:RoundSeed[@actual])" />
      <xsl:for-each select="ft:ArrayOfRound/ft:Round[last()]/ft:ArrayOfRoundSeed/ft:RoundSeed[@actual]">
        <xsl:variable name="cid" select="@cid" />
        <xsl:variable name="team" select="../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$cid]" />
                
        <Result CompetitorID="{$team/ft:TeamExternalID}" RatingThen="" RatingEarned="">
          <xsl:attribute name="ClubID">
            <xsl:if test="$team/ft:TeamClubID = '0'">1</xsl:if>
            <xsl:if test="$team/ft:TeamClubID != '0'">
              <xsl:value-of select="key('ClubsByID', $team/ft:TeamClubID)/ft:FredID" />
            </xsl:if>
          </xsl:attribute>
          
          <xsl:attribute name="Excluded">
            <xsl:choose>
              <xsl:when test="../../..//ft:WDXCompetitor[@cid=$cid and @reason='Exclude']">True</xsl:when>
              <xsl:otherwise>False</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          
          <xsl:attribute name="Place">
            <xsl:call-template name="ConvertSeedValue">
              <xsl:with-param name="seed" select="@actual" />
              <xsl:with-param name="numComps" select="$numComps" />
            </xsl:call-template>
          </xsl:attribute>
          
          <xsl:attribute name="DNF">
            <xsl:call-template name="ConvertDNF">
              <xsl:with-param name="seed" select="." />
            </xsl:call-template>
          </xsl:attribute>
        </Result>
      </xsl:for-each>
    </FinalResults>
  </xsl:template>

  <!-- Round results template -->
  <xsl:template name="ConvertRoundResults">
    <xsl:if test="count(ft:ArrayOfRound/ft:Round[@type != 'Registration' and @type != 'Results']) > 0">
      <RoundResults>
        <xsl:for-each select="ft:ArrayOfRound/ft:Round[@type != 'Registration' and @type != 'Results']">
          <Round Seq="{position()}">
            <xsl:choose>
              <xsl:when test="@type = 'Pool'">
                <xsl:attribute name="Type">Pool</xsl:attribute>
                <xsl:attribute name="Desc">Round #<xsl:value-of select="position()"/> - Pools</xsl:attribute>
                <xsl:call-template name="ConvertSeeding">
                  <xsl:with-param name="roundNum" select="position()"/>
                </xsl:call-template>
                <xsl:call-template name="ConvertPools" />
              </xsl:when>
              
              <xsl:when test="@type = 'Elimination'">
                <xsl:choose>
                  <xsl:when test="ft:EliminationRound[@type='SingleElim']/ft:ArrayOfElimTree/ft:ElimTree[@num='1' and @size='2']">
                    <xsl:attribute name="Type">FO3</xsl:attribute>
                    <xsl:attribute name="Desc">
                      <xsl:text xml:space="preserve">Round #</xsl:text>
                      <xsl:value-of select="position()"/>
                      <xsl:text xml:space="preserve"> - Direct Elimination with Fence-off</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="ft:EliminationRound[@type='Rep16']">
                    <xsl:attribute name="Type">Rep16</xsl:attribute>
                    <xsl:attribute name="Desc">
                      <xsl:text xml:space="preserve">Round #</xsl:text>
                      <xsl:value-of select="position()"/>
                      <xsl:text xml:space="preserve"> - Repechage from 16</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="ft:EliminationRound[@type='Rep32']">
                    <xsl:attribute name="Type">Rep32</xsl:attribute>
                    <xsl:attribute name="Desc">
                      <xsl:text xml:space="preserve">Round #</xsl:text>
                      <xsl:value-of select="position()"/>
                      <xsl:text xml:space="preserve"> - Repechage from 32</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="ft:EliminationRound[@type='APF16']">
                    <xsl:attribute name="Type">APF16</xsl:attribute>
                    <xsl:attribute name="Desc">
                      <xsl:text xml:space="preserve">Round #</xsl:text>
                      <xsl:value-of select="position()"/>
                      <xsl:text xml:space="preserve"> - All Places Fenced from 16</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="ft:EliminationRound[@type='APF8']">
                    <xsl:attribute name="Type">APF8</xsl:attribute>
                    <xsl:attribute name="Desc">
                      <xsl:text xml:space="preserve">Round #</xsl:text>
                      <xsl:value-of select="position()"/>
                      <xsl:text xml:space="preserve"> - All Places Fenced from 8</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="Type">DE</xsl:attribute>
                    <xsl:attribute name="Desc">
                      <xsl:text xml:space="preserve">Round #</xsl:text>
                      <xsl:value-of select="position()"/>
                      <xsl:text xml:space="preserve"> - Direct Elimination</xsl:text>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:call-template name="ConvertSeeding">
                  <xsl:with-param name="roundNum" select="position()"/>
                </xsl:call-template>

                <xsl:for-each select="ft:EliminationRound/ft:ArrayOfElimTree//ft:Table">
                  <Table Seq="{position()}" Of="{count(ft:ArrayOfElimBout/ft:ElimBout)*2}">
                    <xsl:for-each select="ft:ArrayOfElimBout/ft:ElimBout">
                      <Bout Seq="{position()}">
                        <xsl:call-template name="ConvertElimBout" />
                      </Bout>
                    </xsl:for-each>
                  </Table>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
          </Round>
        </xsl:for-each>
        <xsl:for-each select="ft:ArrayOfRound/ft:Round/ft:EliminationRound[@type='Rep16' or @type='Rep32']">
          <Round Seq="{../@num + 1}">
            <xsl:attribute name="Type">DE</xsl:attribute>
            <xsl:attribute name="Desc">
              <xsl:text xml:space="preserve">Round #</xsl:text>
              <xsl:value-of select="../@num + 1"/>
              <xsl:text xml:space="preserve"> - Direct Elimination</xsl:text>
            </xsl:attribute>

            <xsl:for-each select="..">
              <xsl:call-template name="ConvertSeeding">
                <xsl:with-param name="roundNum" select="@num + 1"/>
              </xsl:call-template>
            </xsl:for-each>
            
            <xsl:for-each select="ft:ArrayOfElimTree/ft:ElimTree[last()]/ft:ArrayOfTable/ft:Table">
              <Table Seq="{position()}" Of="{count(ft:ArrayOfElimBout/ft:ElimBout)*2}">
                <xsl:for-each select="ft:ArrayOfElimBout/ft:ElimBout">
                  <Bout Seq="{position()}">
                    <xsl:call-template name="ConvertElimBout" />
                  </Bout>
                </xsl:for-each>
              </Table>
            </xsl:for-each>
          </Round>
        </xsl:for-each>
        
      </RoundResults>
    </xsl:if>
  </xsl:template>

  <!-- Competitor seeding at start of each round -->
  <xsl:template name="ConvertSeeding">
    <xsl:param name="roundNum"/>
    <RoundSeeding>
      <xsl:variable name="numComps" select="count(ft:ArrayOfRoundSeed/ft:RoundSeed[@actual])" />
      <xsl:for-each select="ft:ArrayOfRoundSeed/ft:RoundSeed[@actual]">
        <Competitor>
          <xsl:variable name="ftid" select="@cid" />
          <xsl:variable name="comp" select="../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$ftid]" />

          <!-- Convert the competitor to a FRED ID -->
          <xsl:attribute name="CompetitorID">
            <xsl:call-template name="FTCompToFredCompID">
              <xsl:with-param name="comp" select="$comp" />
            </xsl:call-template>
          </xsl:attribute>

          <!-- Output seed from seeding list -->
          <xsl:attribute name="Seed">
            <xsl:call-template name="ConvertSeedValue">
              <xsl:with-param name="seed" select="@actual" />
              <xsl:with-param name="numComps" select="$numComps" />
            </xsl:call-template>
          </xsl:attribute>

          <!-- Get the status -->
          <xsl:attribute name="Status">
            <xsl:variable name="wdx"  select="../../../ft:Round[position()-1 &lt; $roundNum]/ft:ArrayOfWDXCompetitor/ft:WDXCompetitor[@cid = $ftid]" />
            <xsl:variable name="elim" select="../../../ft:Round[position()-1 &lt; $roundNum]/ft:ArrayOfElimination/ft:Elimination[@cid = $ftid]" />
            <xsl:choose>
              <xsl:when test="$wdx/@reason = 'MedicalWithdraw'">W</xsl:when>
              <xsl:when test="$wdx/@reason = 'Exclude'">X</xsl:when>
              <xsl:when test="$wdx/@reason = 'ScratchNoShow'">E</xsl:when>
              <xsl:when test="$elim">E</xsl:when>
              <xsl:otherwise>P</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </Competitor>
      </xsl:for-each>
    </RoundSeeding>
  </xsl:template>

  <xsl:template name="ConvertPools">
    <xsl:for-each select="ft:PoolRound/ft:ArrayOfPool/ft:Pool">
      <Pool Seq="{position()}">
        <xsl:for-each select="ft:ArrayOfPoolResult/ft:PoolResult">
          <xsl:variable name="ftid" select="@cid" />
          <Competitor CompetitorNum="{position()}" Bouts="{ft:M}" Victories="{ft:V}" TS="{ft:TS}" TR="{ft:TR}" Ind="{number(ft:TS) - number(ft:TR)}" Rank="{ft:Place}">
            <xsl:attribute name="CompetitorID">
              <xsl:variable name="comp" select="../../../../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$ftid]" />
              <xsl:call-template name="FTCompToFredCompID">
                <xsl:with-param name="comp" select="$comp" />
              </xsl:call-template>
            </xsl:attribute>
          </Competitor>
        </xsl:for-each>
        
        <xsl:for-each select="ft:ArrayOfPoolBout/ft:PoolBout">
          <Bout>
            <Competitor Score="{substring(ft:Score1, 2)}" Status="{substring(ft:Score1, 1, 1)}">
              <xsl:attribute name="CompetitorID">
                <xsl:variable name="ftid" select="ft:Comp1ID" />
                <xsl:variable name="comp" select="../../../../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$ftid]" />
                <xsl:call-template name="FTCompToFredCompID">
                  <xsl:with-param name="comp" select="$comp" />
                </xsl:call-template>
              </xsl:attribute>
            </Competitor>
            <Competitor Score="{substring(ft:Score2, 2)}" Status="{substring(ft:Score2, 1, 1)}">
              <xsl:attribute name="CompetitorID">
                <xsl:variable name="ftid" select="ft:Comp2ID" />
                <xsl:variable name="comp" select="../../../../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$ftid]" />
                <xsl:call-template name="FTCompToFredCompID">
                  <xsl:with-param name="comp" select="$comp" />
                </xsl:call-template>
              </xsl:attribute>
            </Competitor>

            <!-- Team match data if present -->
            <xsl:if test="ft:TeamMatch">
              <xsl:call-template name="ConvertTeamMatch">
                <xsl:with-param name="teamList" select="../../../../../../../ft:ArrayOfCompetitor" />
              </xsl:call-template>
            </xsl:if>
          </Bout>
        </xsl:for-each>
      </Pool>
    </xsl:for-each>
  </xsl:template>

  <!-- Elimination bout data -->
  <xsl:template name="ConvertElimBout">
    <!-- Top competitor information -->
    <xsl:if test="ft:ByeTop='True'">
      <Bye Called="1" />
    </xsl:if>
    <xsl:if test="ft:ByeTop='False'">
      <Competitor Called="1">
        <xsl:attribute name="CompetitorID">
          <xsl:variable name="ftid" select="ft:Comp1ID" />
          <xsl:variable name="comp" select="../../../../../../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$ftid]" />
          <xsl:call-template name="FTCompToFredCompID">
            <xsl:with-param name="comp" select="$comp" />
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="Score">
          <xsl:if test="ft:ByeBot='False'">
            <xsl:value-of select="substring(ft:Score1, 2)" />
          </xsl:if>
          <xsl:if test="ft:ByeBot='True'">0</xsl:if>
        </xsl:attribute>
        <xsl:attribute name="Status">
          <xsl:choose>
            <xsl:when test="ft:Score1 != ''">
              <xsl:value-of select="substring(ft:Score1, 1, 1)" />
            </xsl:when>
            <xsl:otherwise>V</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </Competitor>
    </xsl:if>

    <!-- Bottom competitor information -->
    <xsl:if test="ft:ByeBot='True'">
      <Bye Called="2" />
    </xsl:if>
    <xsl:if test="ft:ByeBot='False'">
      <Competitor Called="2">
        <xsl:attribute name="CompetitorID">
          <xsl:variable name="ftid" select="ft:Comp2ID" />
          <xsl:variable name="comp" select="../../../../../../../../../ft:ArrayOfCompetitor/ft:Competitor[@id=$ftid]" />
          <xsl:call-template name="FTCompToFredCompID">
            <xsl:with-param name="comp" select="$comp" />
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="Score">
          <xsl:if test="ft:ByeTop='False'">
            <xsl:value-of select="substring(ft:Score2, 2)" />
          </xsl:if>
          <xsl:if test="ft:ByeTop='True'">0</xsl:if>
        </xsl:attribute>
        <xsl:attribute name="Status">
          <xsl:choose>
            <xsl:when test="ft:Score2 != ''">
              <xsl:value-of select="substring(ft:Score2, 1, 1)" />
            </xsl:when>
            <xsl:otherwise>V</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </Competitor>
    </xsl:if>

    <!-- Team match data if present -->
    <xsl:if test="ft:TeamMatch">
      <xsl:call-template name="ConvertTeamMatch">
        <xsl:with-param name="teamList" select="../../../../../../../../../ft:ArrayOfCompetitor" />
      </xsl:call-template>
    </xsl:if>

    <!-- If youth scores present, add them -->
    <xsl:if test="ft:TopScore1 and ft:ByeTop='False' and ft:ByeBot='False'">
      <xsl:call-template name="ConvertYouthDE">
        <xsl:with-param name="compList" select="../../../../../../../../../ft:ArrayOfCompetitor" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Write youth DE match data -->
  <xsl:template name="ConvertYouthDE">
    <xsl:param name="compList" />
    <YouthMatch>
      <!-- Get Fred IDs of the competitors -->
      <xsl:variable name="fredId1">
        <xsl:variable name="ftid" select="ft:Comp1ID" />
        <xsl:variable name="comp" select="$compList/ft:Competitor[@id=$ftid]" />
        <xsl:call-template name="FTCompToFredCompID">
          <xsl:with-param name="comp" select="$comp" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="fredId2">
        <xsl:variable name="ftid" select="ft:Comp2ID" />
        <xsl:variable name="comp" select="$compList/ft:Competitor[@id=$ftid]" />
        <xsl:call-template name="FTCompToFredCompID">
          <xsl:with-param name="comp" select="$comp" />
        </xsl:call-template>
      </xsl:variable>

      <!-- First bout of three -->
      <xsl:call-template name="ConvertYouthBout">
        <xsl:with-param name="seq" select="1" />
        <xsl:with-param name="fredId1" select="$fredId1" />
        <xsl:with-param name="fredId2" select="$fredId2" />
        <xsl:with-param name="score1node" select="ft:TopScore1" />
        <xsl:with-param name="score2node" select="ft:BotScore1" />
      </xsl:call-template>

      <!-- Second bout of three -->
      <xsl:call-template name="ConvertYouthBout">
        <xsl:with-param name="seq" select="2" />
        <xsl:with-param name="fredId1" select="$fredId1" />
        <xsl:with-param name="fredId2" select="$fredId2" />
        <xsl:with-param name="score1node" select="ft:TopScore2" />
        <xsl:with-param name="score2node" select="ft:BotScore2" />
      </xsl:call-template>

      <!-- Third bout of three, only if necessary -->
      <xsl:if test="ft:TopScore3 != '' and ft:BotScore3 != ''">
        <xsl:call-template name="ConvertYouthBout">
          <xsl:with-param name="seq" select="3" />
          <xsl:with-param name="fredId1" select="$fredId1" />
          <xsl:with-param name="fredId2" select="$fredId2" />
          <xsl:with-param name="score1node" select="ft:TopScore3" />
          <xsl:with-param name="score2node" select="ft:BotScore3" />
        </xsl:call-template>
      </xsl:if>
    </YouthMatch>
  </xsl:template>

  <!-- Emit a youth sub-bout -->
  <xsl:template name="ConvertYouthBout">
    <xsl:param name="seq" />
    <xsl:param name="fredId1" />
    <xsl:param name="fredId2" />
    <xsl:param name="score1node" />
    <xsl:param name="score2node" />

    <Bout Seq="{$seq}">
      <Competitor Called="1" CompetitorID="{$fredId1}" >
        <xsl:attribute name="Score">
          <xsl:value-of select="substring($score1node, 2)" />
        </xsl:attribute>
        <xsl:attribute name="Status">
          <xsl:value-of select="substring($score1node, 1, 1)" />
        </xsl:attribute>
      </Competitor>
      <Competitor Called="2" CompetitorID="{$fredId2}" >
        <xsl:attribute name="Score">
          <xsl:value-of select="substring($score2node, 2)" />
        </xsl:attribute>
        <xsl:attribute name="Status">
          <xsl:value-of select="substring($score2node, 1, 1)" />
        </xsl:attribute>
      </Competitor>
    </Bout>
  </xsl:template>

  <!-- Write team match data -->
  <xsl:template name="ConvertTeamMatch">
    <xsl:param name="teamList" />
    
    <xsl:variable name="match" select="ft:TeamMatch" />
    <TeamMatch>
      <xsl:variable name="ftidRight" select="$match/ft:TeamRightID" />
      <xsl:variable name="rightTeam" select="$teamList/ft:Competitor[@id=$ftidRight]" />
      <xsl:variable name="ftidLeft" select="$match/ft:TeamLeftID" />
      <xsl:variable name="leftTeam" select="$teamList/ft:Competitor[@id=$ftidLeft]" />
      
      <xsl:attribute name="ATeam">
        <xsl:value-of select="$rightTeam/ft:ExternalFredID" />
      </xsl:attribute>
      
      <Encounters>
        <xsl:for-each select="$match/ft:ArrayOfTeamEncounter/ft:TeamEncounter">
          <Encounter Seq="{position()}" AScore="{ft:RightScore}" BScore="{ft:LeftScore}">
            <xsl:attribute name="AFencerID">
              <xsl:call-template name="GetTeamFencerFredID">
                <xsl:with-param name="fenIndex" select="ft:RightFencerIndex"/>
                <xsl:with-param name="team"     select="$rightTeam"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="BFencerID">
              <xsl:call-template name="GetTeamFencerFredID">
                <xsl:with-param name="fenIndex" select="ft:LeftFencerIndex"/>
                <xsl:with-param name="team"     select="$leftTeam"/>
              </xsl:call-template>
            </xsl:attribute>
          </Encounter>
        </xsl:for-each>
      </Encounters>
    </TeamMatch>
  </xsl:template>

  <xsl:template name="GetTeamFencerFredID">
    <xsl:param name="fenIndex" />
    <xsl:param name="team" />
    
    <xsl:variable name="fen" select="$team/ft:ArrayOfEventFencer/ft:EventFencer[$fenIndex + 1]" />
    <xsl:if test="$fen">
      <xsl:value-of select="key('FencersByID', $fen/@id)/ft:FredID" />
    </xsl:if>
    <xsl:if test="not($fen)">0</xsl:if>
  </xsl:template>
  
  
  <!-- Convert qualifier bitfield to mutliple Qualified elements -->
  <xsl:template name="AddQuals">
    <xsl:param name="pow2" />
    <xsl:param name="value" />
    <xsl:param name="compID" />

    <xsl:if test="$pow2 &lt;= 256">
      <xsl:if test="floor($value div $pow2) mod 2 = 1">
        <Qualified CompetitorID="{$compID}" Weapon="{../../../../../ft:Weapon}">
          <xsl:attribute name="QualFor">
            <xsl:choose>
              <xsl:when test="$pow2 = 1">D1A</xsl:when>
              <xsl:when test="$pow2 = 2">DV2</xsl:when>
              <xsl:when test="$pow2 = 4">DV3</xsl:when>
              <xsl:when test="$pow2 = 16">Y14</xsl:when>
              <xsl:when test="$pow2 = 32">U20</xsl:when>
              <xsl:when test="$pow2 = 64">U17</xsl:when>
              <xsl:when test="$pow2 = 256">VET</xsl:when>
            </xsl:choose> 
          </xsl:attribute>
          <xsl:attribute name="Gender">
            <xsl:call-template name="ConvertGender">
              <xsl:with-param name="gen" select="../../../../../ft:GenderMix" />
            </xsl:call-template>
          </xsl:attribute>
        </Qualified>
      </xsl:if>
      
      <!-- Recursively call with next bit -->
      <xsl:call-template name="AddQuals">
        <xsl:with-param name="pow2"   select="$pow2 * 2" />
        <xsl:with-param name="value"  select="$value" />
        <xsl:with-param name="compID" select="$compID" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Rating conversion -->
  <xsl:template name="ConvertRating">
    <xsl:param name="rating" />
    <xsl:choose>
      <xsl:when test="not($rating)">U</xsl:when>
      <xsl:when test="$rating=''"></xsl:when>
      <xsl:when test="$rating='U'">U</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($rating, 1, 1)" />20<xsl:value-of select="substring($rating, 2, 2)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Seed conversion (remove 'T') -->
  <xsl:template name="ConvertSeedValue">
    <xsl:param name="seed" />
    <xsl:param name="numComps" />
    <xsl:choose>
      <xsl:when test="contains($seed, 'T')">
        <xsl:value-of select="substring-before($seed, 'T')" />
      </xsl:when>
      <!-- TODO: Remove this when FRED accepts 'DNF' -->
      <xsl:when test="contains($seed, 'DNF')">
        <xsl:value-of select="$numComps" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$seed" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Seed conversion to DNF -->
  <xsl:template name="ConvertDNF">
    <xsl:param name="seed" />
    <xsl:choose>
      <xsl:when test="contains($seed, 'DNF')">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Event gender -->
  <xsl:template name="ConvertGender">
    <xsl:param name="gen" />
    <xsl:choose>
      <xsl:when test="starts-with($gen, 'Men')">Men</xsl:when>
      <xsl:when test="starts-with($gen, 'Women')">Women</xsl:when>
      <xsl:otherwise>Mixed</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Event age limit -->
  <xsl:template name="ConvertAgeLimit">
    <xsl:param name="age" />
    <xsl:choose>
      <xsl:when test="$age='FIE|V50'">Vet50</xsl:when>
      <xsl:when test="$age='FIE|V60'">Vet60</xsl:when>
      <xsl:when test="$age='FIE|V70'">Vet70</xsl:when>
      <xsl:when test="$age='FIE|SR'">Senior</xsl:when>
      <xsl:when test="$age='FIE|JR'">Junior</xsl:when>
      <xsl:when test="$age='FIE|CDT'">Cadet</xsl:when>
      
      <xsl:when test="$age='USFA|VET'">VetCombined</xsl:when>
      <xsl:when test="$age='USFA|V40'">Vet40</xsl:when>
      <xsl:when test="$age='USFA|U19'">U19</xsl:when>
      <xsl:when test="$age='USFA|U16'">U16</xsl:when>
      <xsl:when test="$age='USFA|Y14'">Y14</xsl:when>
      <xsl:when test="$age='USFA|Y12'">Y12</xsl:when>
      <xsl:when test="$age='USFA|Y10'">Y10</xsl:when>
      <xsl:when test="$age='USFA|Y8'">Y8</xsl:when>

      <xsl:when test="$age='CFF|VET'">VetCombined</xsl:when>
      <xsl:when test="$age='CFF|V40'">Vet40</xsl:when>
      <xsl:when test="$age='CFF|Y15'">U16</xsl:when>
      <xsl:when test="$age='CFF|Y14'">Y14</xsl:when>
      <xsl:when test="$age='CFF|Y12'">Y12</xsl:when>
      <xsl:when test="$age='CFF|Y10'">Y10</xsl:when>
      <xsl:when test="$age='CFF|Y8'">Y8</xsl:when>

      <xsl:when test="$age='CFF|S11'">Senior</xsl:when>
      <xsl:when test="$age='CFF|J11'">Junior</xsl:when>
      <xsl:when test="$age='CFF|C11'">Cadet</xsl:when>
      <xsl:when test="$age='CFF|U15'">Y14</xsl:when>
      <xsl:when test="$age='CFF|U13'">Y12</xsl:when>

<!--       
      <xsl:when test="$age='CFF|Y16'"></xsl:when>
      <xsl:when test="$age='CFF|Y13'"></xsl:when>
      <xsl:when test="$age='CFF|Y11'"></xsl:when>
      <xsl:when test="$age='CFF|Y9'"></xsl:when>
      <xsl:when test="$age='CFF|UNI'"></xsl:when>
 -->      
      <xsl:otherwise>None</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Event rating level -->
  <xsl:template name="ConvertLevel">
    <xsl:param name="lev" />
    <xsl:choose>
      <xsl:when test="$lev='Unrated'">Unrated</xsl:when>
      <xsl:when test="$lev='EAndUnder'">EUnder</xsl:when>
      <xsl:when test="$lev='DivIII'">Div3</xsl:when>
      <xsl:when test="$lev='DivII'">Div2</xsl:when>
      <xsl:when test="$lev='DivI'">Div1</xsl:when>
      <xsl:when test="$lev='DivIA'">Div1A</xsl:when>
      <xsl:otherwise>Open</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Event class -->
  <xsl:template name="ConvertEventClass">
    <xsl:param name="ec" />
    <xsl:choose>
      <xsl:when test="$ec='Unrated'">NR</xsl:when>
      <xsl:when test="$ec='E1'">E1</xsl:when>
      <xsl:when test="$ec='D1'">D1</xsl:when>
      <xsl:when test="$ec='C1'">C1</xsl:when>
      <xsl:when test="$ec='C2'">C2</xsl:when>
      <xsl:when test="$ec='C3'">C3</xsl:when>
      <xsl:when test="$ec='B1'">B1</xsl:when>
      <xsl:when test="$ec='B2'">B2</xsl:when>
      <xsl:when test="$ec='B3'">B3</xsl:when>
      <xsl:when test="$ec='A1'">A1</xsl:when>
      <xsl:when test="$ec='A2'">A2</xsl:when>
      <xsl:when test="$ec='A3'">A3</xsl:when>
      <xsl:when test="$ec='A4'">A4</xsl:when>
      <xsl:when test="$ec='B2/C3'">B2C3</xsl:when>
      <xsl:when test="$ec='A2/C3'">A2C3</xsl:when>
      <xsl:when test="$ec='A2/B3'">A2B3</xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Convert a competitor to a FRED CompetitorID -->
  <xsl:template name="FTCompToFredCompID">
    <xsl:param name="comp"/>
    <xsl:if test="$comp/@type = 'ind'">
      <xsl:value-of select="key('FencersByID', $comp/ft:ArrayOfEventFencer/ft:EventFencer[1]/@id)/ft:FredID" />
    </xsl:if>
    <xsl:if test="$comp/@type = 'team'">
      <xsl:value-of select="$comp/ft:TeamExternalID"/>
    </xsl:if>
  </xsl:template>

  <!-- Include XSLT to handle division conversions -->
  <xsl:include href="ConvertDivisions.xslt" />
</xsl:stylesheet>
