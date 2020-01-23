<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<!-- Tournament import for FRED APIVersion 4.0 data -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:fred="http://www.askfred.net" xmlns="http://www.fencingtime.com">
  <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes"/>
  <xsl:variable name="fileVersion">4.4</xsl:variable>

  <xsl:param name="auth" />
  
  <!-- Mapping definitions -->
  <xsl:key name="FencersByID" match="/fred:FencingData/fred:FencerDatabase/fred:Fencer" use="@FencerID" />
  <xsl:key name="TeamsByID"   match="/fred:FencingData/fred:TeamDatabase/fred:Team"     use="@TeamID" />
 
  <!-- Main template matching rule -->
  <xsl:template match="/fred:FencingData">
    <FencingTimeData version="4.4">
      <ExternalDatabase databaseID="35C68D00-605E-476A-9CF9-BFF643836FED">
        <xsl:apply-templates select="fred:ClubDatabase"/>
        <xsl:apply-templates select="fred:FencerDatabase"/>
      </ExternalDatabase>
      <xsl:apply-templates select="fred:Tournament"/>
    </FencingTimeData>
  </xsl:template>

  <!-- Club template rule -->
  <xsl:template match="fred:ClubDatabase">
    <ArrayOfClub>
      <xsl:for-each select="fred:Club[@ClubID != '1']">
        <Club id="{@ClubID}">
          <Name><xsl:value-of select="@Name" /></Name>
          <Abbreviation><xsl:value-of select="@Abbreviation" /></Abbreviation>
          <Location><xsl:value-of select="@City" /><xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="@State" /></Location>
          <FredID><xsl:value-of select="@ClubID" /></FredID>
          <MemberNum />
          <xsl:call-template name="FredDivIDToDivAndCountry">
            <xsl:with-param name="fid" select="@DivisionID"/>
          </xsl:call-template>
        </Club>
      </xsl:for-each>
    </ArrayOfClub>
  </xsl:template>

  <!-- Fencer template rule -->
  <xsl:template match="fred:FencerDatabase">
    <ArrayOfFencer>
      <xsl:for-each select="fred:Fencer">
        <Fencer id="{@FencerID}">
          <LastName><xsl:value-of select="@LastName" /></LastName>
          <FirstName><xsl:value-of select="@FirstName" /></FirstName>
          <MiddleName><xsl:value-of select="@MiddleName" /></MiddleName>
          <Suffix><xsl:value-of select="@Suffix" /></Suffix>
          <Nickname><xsl:value-of select="@NickName" /></Nickname>
          <FredID><xsl:value-of select="@FencerID" /></FredID>
          <Gender><xsl:value-of select="@Gender" /></Gender>
          <Handedness>R</Handedness>
          
          <xsl:if test="@BirthYear">
            <BirthDate><xsl:value-of select="@BirthYear" />-01-01T00:00:00</BirthDate>
          </xsl:if>
          <xsl:if test="not(@BirthYear)">
            <BirthDate />
          </xsl:if>
          
          <xsl:choose>
            <xsl:when test="@ClubID1 = '1'">
              <Club1>0</Club1>
            </xsl:when>
            <xsl:when test="@ClubID1">
              <Club1><xsl:value-of select="@ClubID1"/></Club1>
            </xsl:when>
            <xsl:otherwise>
              <Club1>0</Club1>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="@ClubID2 = '1'">
              <Club2>0</Club2>
            </xsl:when>
            <xsl:when test="@ClubID2">
              <Club2><xsl:value-of select="@ClubID2"/></Club2>
            </xsl:when>
            <xsl:otherwise>
              <Club2>0</Club2>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:call-template name="FredDivIDToDivAndCountry">
            <xsl:with-param name="fid" select="@DivisionID"/>
          </xsl:call-template>

          <ArrayOfMembership>
            <xsl:for-each select="fred:Membership">
              <Membership authority="{@Org}">
                <xsl:if test="@Expires">
                  <xsl:attribute name="expirationDate"><xsl:value-of select="@Expires" />-07-31T00:00:00</xsl:attribute>
                </xsl:if>
                <xsl:if test="not(@Expires)">
                  <xsl:attribute name="expirationDate" />
                </xsl:if>
                <xsl:value-of select="." />
              </Membership>
            </xsl:for-each>
          </ArrayOfMembership>

          <ArrayOfWeaponRating>
            <xsl:for-each select="fred:Rating">
              <xsl:variable name="rating">
                <xsl:call-template name="ConvertWeaponRating">
                  <xsl:with-param name="rstr" select="." />
                </xsl:call-template>
              </xsl:variable>
              <xsl:if test="string-length($rating) != 0">
                <WeaponRating weapon="{@Weapon}" authority="{@Org}"><xsl:value-of select="$rating" /></WeaponRating>
              </xsl:if>
            </xsl:for-each>
          </ArrayOfWeaponRating>

          <ArrayOfRefereeRating />
        </Fencer>
      </xsl:for-each>
    </ArrayOfFencer>
  </xsl:template>

  <!-- Tournament template rule -->
  <xsl:template match="fred:Tournament">
    <Tournament>
      <Name><xsl:value-of select="@Name" /></Name>
      <Location><xsl:value-of select="@Location" /></Location>
      <RegFee><xsl:value-of select="@Fee" /></RegFee>
      <Authority><xsl:value-of select="$auth" /></Authority>
      <ExternalID><xsl:value-of select="@TournamentID" /></ExternalID>
      <ExternalIDType>AskFRED</ExternalIDType>
      <StartDate><xsl:value-of select="@StartDate" />T00:00:00</StartDate>
      <EndDate>
        <xsl:choose>
          <xsl:when test="@EndDate='0000-00-00'"><xsl:value-of select="@StartDate" />T00:00:00</xsl:when>
          <xsl:otherwise><xsl:value-of select="@EndDate" />T00:00:00</xsl:otherwise>
        </xsl:choose>
      </EndDate>

      <!-- Collect reg fees -->
      <ArrayOfRegFee>
        <xsl:for-each select="/fred:FencingData/fred:FencerDatabase/fred:Fencer">
          <xsl:variable name="fid" select="@FencerID" />
          <xsl:variable name="feeNodes" select="/fred:FencingData/fred:Tournament/fred:Event[@IsTeam='False']//fred:PreReg[@TournamentFeePaid!='' and @CompetitorID=$fid]" />
          <xsl:if test="$feeNodes">
            <RegFee fencerID="{$fid}"><xsl:value-of select="$feeNodes[1]/@TournamentFeePaid" /></RegFee>
          </xsl:if>
        </xsl:for-each>
      </ArrayOfRegFee>
      
      <ArrayOfRegNote />
      <ArrayOfRanking />

      <ArrayOfEvent>
        <xsl:for-each select="fred:Event">
          <xsl:variable name="type">
            <xsl:if test="@IsTeam='False'">ind</xsl:if>
            <xsl:if test="@IsTeam='True'">team</xsl:if>
          </xsl:variable>

          <Event id="{@EventID}" type="{$type}">
            <xsl:variable name="weap" select="@Weapon" />
        
            <DispIndex><xsl:value-of select="position()-1" /></DispIndex>
            <DateTime>
              <xsl:value-of select="substring-before(@EventDateTime, ' ')" />
              <xsl:text xml:space="preserve">T</xsl:text>              
              <xsl:value-of select="substring-after(@EventDateTime, ' ')" />
            </DateTime>
            <EntryFee><xsl:value-of select="@Fee" /></EntryFee>
            <Weapon><xsl:value-of select="$weap" /></Weapon>
            <GenderMix><xsl:call-template name="ConvertEventGender" /></GenderMix>
            <Wheelchair>None</Wheelchair>
            <ScratchExcluded>
              <xsl:if test="$auth  = 'USFA'">False</xsl:if>
              <xsl:if test="$auth != 'USFA'">True</xsl:if>
            </ScratchExcluded>
            <AgeLimit>
              <xsl:call-template name="ConvertAgeLimit">
                <xsl:with-param name="auth" select="$auth" />
              </xsl:call-template>
            </AgeLimit>
            <ExternalID><xsl:value-of select="@EventID" /></ExternalID>
            <Level><xsl:call-template name="ConvertEventLevel" /></Level>
            
            <SeedStrategy>
              <xsl:attribute name="type">
                <xsl:choose>
                  <xsl:when test="$type='ind' and $auth='USFA'">SeedByRating</xsl:when>
                  <xsl:when test="$type='team'">SeedByTeamPoints</xsl:when>
                  <xsl:otherwise>SeedByRank</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <PointList1>
                <xsl:if test="$type='ind' and $auth!='USFA'">FIE Sr</xsl:if>
              </PointList1>
              <PointList2 />
              <NumProt>0</NumProt>
              <AllowSwapProt>True</AllowSwapProt>
              <SeedFromEventID />
            </SeedStrategy>
      
            <ArrayOfCompetitor>
              <xsl:for-each select="fred:PreReg">
                <Competitor id="{position()}" type="{$type}">
                  <EventFeePaid><xsl:value-of select="@EventFeePaid" /></EventFeePaid>
                  <CheckInState>Absent</CheckInState>
                  
                  <xsl:if test="$type='ind'">
                    <MemAuth><xsl:value-of select="$auth" /></MemAuth>
                  </xsl:if>
                  
                  <xsl:if test="$type='team'">
                    <xsl:variable name="team" select="key('TeamsByID', @CompetitorID)" />
                    <TeamName><xsl:value-of select="$team/@Name" /></TeamName>
                    <TeamCaptain />
                    <TeamExternalID><xsl:value-of select="$team/@TeamID" /></TeamExternalID>
                    <TeamRegNotes />
                    <TeamRegFeePaid><xsl:value-of select="@TournamentFeePaid" /></TeamRegFeePaid>
                    <TeamClubID>
                      <xsl:choose>
                        <xsl:when test="$team/@ClubID and $team/@ClubID != '1'"><xsl:value-of select="$team/@ClubID" /></xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                      </xsl:choose>
                    </TeamClubID>
                    <xsl:call-template name="FredDivIDToDivAndCountry">
                      <xsl:with-param name="fid" select="$team/@DivisionID"/>
                    </xsl:call-template>
                  </xsl:if>
                  
                  <ArrayOfEventFencer>
                    <xsl:if test="$type='ind'">
                      <xsl:call-template name="EventFencer">
                        <xsl:with-param name="fencer" select="key('FencersByID', @CompetitorID)" />
                        <xsl:with-param name="weap"   select="$weap" />
                        <xsl:with-param name="auth"   select="$auth" />
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$type='team'">
                      <xsl:variable name="team" select="key('TeamsByID', @CompetitorID)" />
                      <xsl:for-each select="$team/fred:Fencer">
                        <xsl:call-template name="EventFencer">
                          <xsl:with-param name="fencer" select="key('FencersByID', @FencerID)" />
                          <xsl:with-param name="weap"   select="$weap" />
                          <xsl:with-param name="auth"   select="$auth" />
                        </xsl:call-template>
                      </xsl:for-each>
                    </xsl:if>
                  </ArrayOfEventFencer>
                  
                </Competitor>
              </xsl:for-each>
            </ArrayOfCompetitor>
        
            <ArrayOfRound>
              <Round type="Registration" num="0">
                <Finished>True</Finished>
                <NumByes>0</NumByes>
                <ArrayOfRoundSeed>
                  <xsl:for-each select="fred:PreReg">
                    <RoundSeed cid="{position()}"><xsl:value-of select="position()" /></RoundSeed>
                  </xsl:for-each>
                </ArrayOfRoundSeed>
                <ArrayOfWDXCompetitor />
                <ArrayOfElimination />
              </Round>
            </ArrayOfRound>
          </Event>
        </xsl:for-each>
      </ArrayOfEvent>

      <ArrayOfFeed>
        <Feed>
          <Name>Default Feed</Name>
          <OmittedItems>33280</OmittedItems>
          <DisplayOptions>115</DisplayOptions>
          <AnnouncementMessage />
          <AnnouncementPriority>High</AnnouncementPriority>
          <AnnouncementOffTime>2014-01-01T00:00:00</AnnouncementOffTime>
          <ArrayOfEvent />
        </Feed>
        <Feed>
          <Name>Referee Strip Assignments</Name>
          <OmittedItems>0</OmittedItems>
          <DisplayOptions>512</DisplayOptions>
          <AnnouncementMessage />
          <AnnouncementPriority>High</AnnouncementPriority>
          <AnnouncementOffTime>2014-01-01T00:00:00</AnnouncementOffTime>
          <ArrayOfEvent />
        </Feed>
      </ArrayOfFeed>
    </Tournament>
  </xsl:template>

  <xsl:template name="EventFencer">
    <xsl:param name="fencer" />
    <xsl:param name="weap" />
    <xsl:param name="auth" />
    
    <EventFencer id="{$fencer/@FencerID}">
      <WeaponRating>
        <xsl:call-template name="ConvertWeaponRating">
          <xsl:with-param name="rstr" select="$fencer/fred:Rating[@Org=$auth and @Weapon=$weap]" />
        </xsl:call-template>
      </WeaponRating>
      <Rank1>0</Rank1>
      <Rank2>0</Rank2>
      <Club1ID>
        <xsl:choose>
          <xsl:when test="$fencer/@ClubID1 and $fencer/@ClubID1 != '1'"><xsl:value-of select="$fencer/@ClubID1" /></xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </Club1ID>
      <Club2ID>
        <xsl:choose>
          <xsl:when test="$fencer/@ClubID2 and $fencer/@ClubID2 != '1'"><xsl:value-of select="$fencer/@ClubID2" /></xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </Club2ID>

      <xsl:call-template name="FredDivIDToDivAndCountry">
        <xsl:with-param name="fid" select="$fencer/@DivisionID"/>
      </xsl:call-template>
    </EventFencer>
  </xsl:template>
  
  
  <!-- Letter weapon ratings -->
  <xsl:template name="ConvertWeaponRating">
    <xsl:param name="rstr" />
    <xsl:choose>
      <xsl:when test="starts-with($rstr,'U') or starts-with($rstr,'u')"></xsl:when>
      <xsl:when test="string-length($rstr) = 5"><xsl:value-of select="substring($rstr, 1, 1)" /><xsl:value-of select="substring($rstr, 4, 2)" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$rstr" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Event gender -->
  <xsl:template name="ConvertEventGender">
    <xsl:choose>
      <xsl:when test="@Gender='Men'">Mens</xsl:when>
      <xsl:when test="@Gender='Women'">Womens</xsl:when>
      <xsl:otherwise>Mixed</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Event age limit -->
  <xsl:template name="ConvertAgeLimit">
    <xsl:param name="auth" />
    <xsl:choose>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Senior'">CFF|S11</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Junior'">CFF|J11</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Cadet'">CFF|C11</xsl:when>

      <xsl:when test="@AgeLimitMax='Senior'">FIE|SR</xsl:when>
      <xsl:when test="@AgeLimitMax='Junior'">FIE|JR</xsl:when>
      <xsl:when test="@AgeLimitMax='Cadet'">FIE|CDT</xsl:when>
      <xsl:when test="@AgeLimitMax='Vet50'">FIE|V50</xsl:when>
      <xsl:when test="@AgeLimitMax='Vet60'">FIE|V60</xsl:when>
      <xsl:when test="@AgeLimitMax='Vet70'">FIE|V70</xsl:when>

      <xsl:when test="$auth='USFA' and @AgeLimitMax='VetCombined'">USFA|VET</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='Vet40'">USFA|V40</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='U19'">USFA|U19</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='U16'">USFA|U16</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='Y14'">USFA|Y14</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='Y12'">USFA|Y12</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='Y10'">USFA|Y10</xsl:when>
      <xsl:when test="$auth='USFA' and @AgeLimitMax='Y8'">USFA|Y8</xsl:when>

      <xsl:when test="$auth='CFF' and @AgeLimitMax='VetCombined'">CFF|VET</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Vet40'">CFF|V40</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='U19'">FIE|JR</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='U16'">CFF|Y15</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Y14'">CFF|Y14</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Y12'">CFF|Y12</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Y10'">CFF|Y10</xsl:when>
      <xsl:when test="$auth='CFF' and @AgeLimitMax='Y8'">CFF|Y8</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Event rating level -->
  <xsl:template name="ConvertEventLevel">
    <xsl:choose>
      <xsl:when test="@RatingLimit='Unrated'">Unrated</xsl:when>
      <xsl:when test="@RatingLimit='EUnder'">EAndUnder</xsl:when>
      <xsl:when test="@RatingLimit='Div3'">DivIII</xsl:when>
      <xsl:when test="@RatingLimit='Div2'">DivII</xsl:when>
      <xsl:when test="@RatingLimit='Div1'">DivI</xsl:when>
      <xsl:when test="@RatingLimit='Div1A'">DivIA</xsl:when>
      <xsl:otherwise>Open</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Include XSLT to handle division conversions -->
  <xsl:include href="ConvertDivisions.xslt"/>
</xsl:stylesheet>

