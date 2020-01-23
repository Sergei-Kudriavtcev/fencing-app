<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<!-- Tournament import for USFA 1.0 data -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:usfa="https://member.usafencing.org/" xmlns="http://www.fencingtime.com">
  <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes"/>
  <xsl:variable name="fileVersion">4.4.1</xsl:variable>

  <!-- Mapping definitions -->
  <xsl:key name="FencersByID" match="/usfa:FencingData/usfa:PersonDatabase/usfa:Person" use="@PersonID" />
  <xsl:key name="TeamsByID"   match="/usfa:FencingData/usfa:TeamDatabase/usfa:Team"     use="@TeamID" />
 
  <!-- Main template matching rule -->
  <xsl:template match="/usfa:FencingData">
    <FencingTimeData version="4.4">
      <ExternalDatabase databaseID="818BB626-3644-4648-9FED-38AA9E6E27DE">
        <xsl:apply-templates select="usfa:ClubDatabase"/>
        <xsl:apply-templates select="usfa:PersonDatabase"/>
      </ExternalDatabase>
      <xsl:apply-templates select="usfa:Tournament"/>
    </FencingTimeData>
  </xsl:template>

  <!-- Club template rule -->
  <xsl:template match="usfa:ClubDatabase">
    <ArrayOfClub>
      <xsl:for-each select="usfa:Club">
        <Club id="{@USFAMemberNum}">
          <Name><xsl:value-of select="@Name" /></Name>
          <Abbreviation><xsl:value-of select="@Abbreviation" /></Abbreviation>
          <Location><xsl:value-of select="@Location" /></Location>
          <MemberNum><xsl:value-of select="@USFAMemberNum" /></MemberNum>
          <Division>
            <xsl:if test="@Division != ''">USFA|<xsl:call-template name="ConvertDivision"><xsl:with-param name="divName" select="@Division" /></xsl:call-template></xsl:if>
          </Division>
          <Country><xsl:value-of select="@Country" /></Country>
        </Club>
      </xsl:for-each>
    </ArrayOfClub>
  </xsl:template>

  <!-- Fencer template rule -->
  <xsl:template match="usfa:PersonDatabase">
    <ArrayOfFencer>
      <xsl:for-each select="usfa:Person">
        <Fencer id="{@PersonID}">
          <LastName><xsl:value-of select="@LastName" /></LastName>
          <FirstName><xsl:value-of select="@FirstName" /></FirstName>
          <MiddleName><xsl:value-of select="@MiddleName" /></MiddleName>
          <Suffix><xsl:value-of select="@Suffix" /></Suffix>
          <Nickname><xsl:value-of select="@NickName" /></Nickname>
          <Gender><xsl:value-of select="@Gender" /></Gender>
          <Handedness><xsl:value-of select="@Handedness" /></Handedness>
          <PhotoURL><xsl:value-of select="@ProfilePicture" /></PhotoURL>
          
          <xsl:if test="@BirthYear">
            <BirthDate><xsl:value-of select="@BirthYear" />-01-01T00:00:00</BirthDate>
          </xsl:if>
          <xsl:if test="not(@BirthYear)">
            <BirthDate />
          </xsl:if>
          <BDVerified><xsl:value-of select="@BirthdateVerified" /></BDVerified>
          <CitVerified><xsl:value-of select="@CitizenshipVerified" /></CitVerified>
          
          <xsl:choose>
            <xsl:when test="@Club1 and @Club1 != ''">
              <Club1><xsl:value-of select="@Club1"/></Club1>
            </xsl:when>
            <xsl:otherwise>
              <Club1>0</Club1>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="@Club2 and @Club2 != ''">
              <Club2><xsl:value-of select="@Club2"/></Club2>
            </xsl:when>
            <xsl:otherwise>
              <Club2>0</Club2>
            </xsl:otherwise>
          </xsl:choose>

          <Division>
            <xsl:if test="@Division != ''">USFA|<xsl:call-template name="ConvertDivision"><xsl:with-param name="divName" select="@Division" /></xsl:call-template></xsl:if>
          </Division>
          <Country><xsl:value-of select="@Country" /></Country>
          <Region>
            <xsl:choose>
              <xsl:when test="@RegionID != ''"><xsl:value-of select="@RegionID" /></xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose> 
          </Region>
          
          <BGExp><xsl:value-of select="usfa:Memberships/usfa:Membership[@Org='USFA']/@BackgroundCheckExpirationDate" /></BGExp>
          <SSExp><xsl:value-of select="usfa:Memberships/usfa:Membership[@Org='USFA']/@SafeSportExpirationDate" /></SSExp>
          
          <ArrayOfMembership>
            <xsl:for-each select="usfa:Memberships/usfa:Membership">
              <Membership authority="{@Org}">
                <xsl:if test="@Expires">
                  <xsl:attribute name="expirationDate"><xsl:value-of select="@Expires" /></xsl:attribute>
                </xsl:if>
                <xsl:if test="not(@Expires)">
                  <xsl:attribute name="expirationDate" />
                </xsl:if>
                
                <xsl:if test="@Org='USFA'">
                  <xsl:attribute name="competitive"><xsl:value-of select="@IsCompetitive" /></xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="@BackgroundCheckExpirationDate and @SafeSportExpirationDate">
                      <xsl:attribute name="checked">True</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="checked">False</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                
                <xsl:value-of select="." />
              </Membership>
            </xsl:for-each>
          </ArrayOfMembership>

          <ArrayOfWeaponRating>
            <xsl:for-each select="usfa:WeaponClassifications/usfa:Classification">
              <WeaponRating weapon="{@Weapon}" authority="{@Org}"><xsl:value-of select="." /></WeaponRating>
            </xsl:for-each>
          </ArrayOfWeaponRating>

          <ArrayOfRefereeRating>
            <xsl:for-each select="usfa:RefereeRatings/usfa:Rating">
              <RefereeRating weapon="{@Weapon}" authority="{@Org}"><xsl:value-of select="." /></RefereeRating>
            </xsl:for-each>
          </ArrayOfRefereeRating>
        </Fencer>
      </xsl:for-each>
    </ArrayOfFencer>
  </xsl:template>

  <!-- Tournament template rule -->
  <xsl:template match="usfa:Tournament">
    <Tournament>
      <Name><xsl:value-of select="@Name" /></Name>
      <Location><xsl:value-of select="@Location" /></Location>
      <City><xsl:value-of select="@City" /></City>
      <State><xsl:value-of select="@State" /></State>
      <Country>USA</Country>
      <RegFee><xsl:value-of select="usfa:Events/usfa:Event[1]/@RegistrationFee" /></RegFee>
      <Authority>USFA</Authority>
      <ExternalID><xsl:value-of select="@TournamentID" /></ExternalID>
      <ExternalIDType>USFA</ExternalIDType>
      <StartDate><xsl:value-of select="@StartDate" />T00:00:00</StartDate>
      <EndDate><xsl:value-of select="@EndDate" />T00:00:00</EndDate>
      <AllowRSE>True</AllowRSE>

      <!-- Collect reg fees -->
      <ArrayOfRegFee>
        <xsl:for-each select="/usfa:FencingData/usfa:PersonDatabase/usfa:Person[@RegistrationFeePaid != '']">
          <RegFee fencerID="{@PersonID}">
            <xsl:value-of select="@RegistrationFeePaid" />
          </RegFee>
        </xsl:for-each>
      </ArrayOfRegFee>
      
      <ArrayOfRegNote>
        <xsl:for-each select="/usfa:FencingData/usfa:RegNoteDatabase/usfa:Note">
          <RegNote fencerID="{@PersonID}">
            <xsl:value-of select="@Note" />
          </RegNote>
        </xsl:for-each>
      </ArrayOfRegNote>

      <ArrayOfRanking>
        <xsl:for-each select="/usfa:FencingData/usfa:PersonDatabase/usfa:Person/usfa:WeaponRankings/usfa:Ranking[@Org='USFA']">
          <xsl:variable name="list">
            <xsl:call-template name="ConvertPointList">
              <xsl:with-param name="pl" select="@List" />
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$list != ''">
            <Ranking fencerID="{../../@PersonID}" weapon="{@Weapon}" pointList="{$list}">
              <xsl:value-of select="." />
            </Ranking>
          </xsl:if>
        </xsl:for-each>
      </ArrayOfRanking>

      <ArrayOfEvent>
        <xsl:for-each select="usfa:Events/usfa:Event">
          <xsl:variable name="type">
            <xsl:if test="@IsTeam = 'False'">ind</xsl:if>
            <xsl:if test="@IsTeam = 'True'">team</xsl:if>
          </xsl:variable>

          <Event id="{@EventID}" type="{$type}">
            <xsl:variable name="weap" select="@Weapon" />
        
            <DispIndex><xsl:value-of select="position()-1" /></DispIndex>
            <DateTime><xsl:value-of select="@EventDateTime" /></DateTime>
            <xsl:if test="$type='ind'">
              <RegDuration>360</RegDuration>
            </xsl:if>

            <ExternalID><xsl:value-of select="@EventID" /></ExternalID>
            <Region><xsl:value-of select="@RegionID" /></Region>
            <EntryFee><xsl:value-of select="@EventFee" /></EntryFee>
            <Weapon><xsl:value-of select="$weap" /></Weapon>
            <GenderMix><xsl:call-template name="ConvertEventGender" /></GenderMix>
            <Wheelchair>
              <xsl:if test="@IsWheelchair = 'True'">Combined</xsl:if>
              <xsl:if test="@IsWheelchair = 'False'">None</xsl:if>
            </Wheelchair>
            <ScratchExcluded>False</ScratchExcluded>
            <AgeLimit><xsl:call-template name="ConvertAgeLimit" /></AgeLimit>
            <Level><xsl:value-of select="@RatingLimit" /></Level>

            <xsl:if test="@EventScope = 'CHAMP'">
              <Championship>True</Championship>
            </xsl:if>
            
            <FormatID>
              <xsl:choose>
                <!-- All team events -->
                <xsl:when test="$type = 'team'">DE_FO3</xsl:when>
                
                <!-- All wheelchair events -->
                <xsl:when test="@IsWheelchair = 'True'">BRAZILIAN</xsl:when>
                
                <!-- NACs -->
                <xsl:when test="@EventScope = 'NAC' and @AgeLimit = 'Junior'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'NAC' and @AgeLimit = 'U19'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'NAC' and @AgeLimit = 'Cadet'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'NAC' and @AgeLimit = 'U16'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'NAC' and @RatingLimit = 'DivI'">POOL_DE_CUT75</xsl:when>

                <!-- Championships -->
                <xsl:when test="@EventScope = 'CHAMP' and @AgeLimit = 'Junior'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @AgeLimit = 'U19'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @AgeLimit = 'Cadet'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @AgeLimit = 'U16'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @RatingLimit = 'DivI'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @RatingLimit = 'DivIA'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @RatingLimit = 'DivII'">POOL_DE_CUT80</xsl:when>
                <xsl:when test="@EventScope = 'CHAMP' and @RatingLimit = 'DivIII'">POOL_DE_CUT80</xsl:when>

                <!-- Everything else (local, regional, etc.) -->
                <xsl:otherwise>POOL_DE</xsl:otherwise>
              </xsl:choose>
            </FormatID>
            
            <!-- Event scopes: RYC, SYC, ROC, RJC, RCC, SCC, SJC, IRC, NAC, CHAMP, DIVQUAL, LOCAL -->
            <QualRuleID>
              <xsl:if test="$type = 'ind'">
                <xsl:choose>
                  <xsl:when test="@EventScope = 'RYC' and @AgeLimit = 'Y14'">500</xsl:when>
                  <xsl:when test="@EventScope = 'RYC' and @AgeLimit = 'Y12'">501</xsl:when>
                  <xsl:when test="@EventScope = 'RYC' and @AgeLimit = 'Y10'">502</xsl:when>
                  <xsl:when test="@EventScope = 'SYC' and @AgeLimit = 'Y14'">503</xsl:when>
                  <xsl:when test="@EventScope = 'SYC' and @AgeLimit = 'Y12'">504</xsl:when>
                  <xsl:when test="@EventScope = 'SYC' and @AgeLimit = 'Y10'">505</xsl:when>
                  <xsl:when test="@EventScope = 'RJC' and @AgeLimit = 'Junior'">506</xsl:when>
                  <xsl:when test="@EventScope = 'RJC' and @AgeLimit = 'U19'">506</xsl:when>
                  <xsl:when test="@EventScope = 'RCC' and @AgeLimit = 'Cadet'">507</xsl:when>
                  <xsl:when test="@EventScope = 'RCC' and @AgeLimit = 'U16'">507</xsl:when>
                  <xsl:when test="@EventScope = 'SJC' and @AgeLimit = 'Junior'">508</xsl:when>
                  <xsl:when test="@EventScope = 'SJC' and @AgeLimit = 'U19'">508</xsl:when>
                  <xsl:when test="@EventScope = 'SCC' and @AgeLimit = 'Cadet'">509</xsl:when>
                  <xsl:when test="@EventScope = 'SCC' and @AgeLimit = 'U16'">509</xsl:when>
                  <xsl:when test="@EventScope = 'ROC' and @RatingLimit = 'DivIA'">100</xsl:when>
                  <xsl:when test="@EventScope = 'ROC' and @RatingLimit = 'DivII'">201</xsl:when>
                  <xsl:when test="@EventScope = 'ROC' and @AgeLimit = 'VetCombined'">400</xsl:when>
                </xsl:choose>
              </xsl:if>
            </QualRuleID>    

            <!-- Choose point lists based on event age/rating limit -->
            <xsl:variable name="pl1">
              <xsl:if test="$type = 'ind' and @EventScope != 'DIVQUAL' and @EventScope != 'LOCAL'">
                <xsl:choose>
                  <xsl:when test="@IsWheelchair = 'True'">USFA CHR</xsl:when>
                  <xsl:when test="@AgeLimit = 'Junior'">USFA JR</xsl:when>
                  <xsl:when test="@AgeLimit = 'U19'">USFA JR</xsl:when>
                  <xsl:when test="@AgeLimit = 'Cadet'">USFA CDT</xsl:when>
                  <xsl:when test="@AgeLimit = 'U16'">USFA CDT</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y14'">USFA Y14</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y12'">USFA Y12</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y10'">USFA Y10</xsl:when>
                  <xsl:when test="@AgeLimit = 'VetCombined'">USFA VET</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet40'">USFA V40</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet50'">USFA V50</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet60'">USFA V60</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet70'">USFA V70</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet80'">USFA V70</xsl:when>  <!-- V80 is seeded by V70 -->
                  <xsl:when test="@RatingLimit = 'DivI'">USFA SR</xsl:when>
                  <xsl:when test="@RatingLimit = 'DivIA'">USFA SR</xsl:when>
                </xsl:choose>
              </xsl:if>
              <xsl:if test="$type ='team' and @EventScope != 'DIVQUAL' and @EventScope != 'LOCAL'">
                <xsl:choose>
                  <xsl:when test="@RatingLimit = 'DivI'">USFA SR</xsl:when>
                  <xsl:when test="@AgeLimit = 'Senior'">USFA SR</xsl:when>
                  <xsl:when test="@AgeLimit = 'Junior'">USFA JR</xsl:when>
                  <xsl:when test="@AgeLimit = 'U19'">USFA JR</xsl:when>
                  <xsl:when test="@AgeLimit = 'Cadet'">USFA CDT</xsl:when>
                  <xsl:when test="@AgeLimit = 'U16'">USFA CDT</xsl:when>
                  <xsl:when test="@AgeLimit = 'VetCombined'">USFA VET</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y14'">USFA Y14</xsl:when>
                </xsl:choose>
              </xsl:if>
            </xsl:variable>

            <!-- Choose protection number based on event age/rating limit -->
            <xsl:variable name="prot">
              <xsl:if test="$type = 'ind' and @EventScope != 'DIVQUAL' and @EventScope != 'LOCAL'">
                <xsl:choose>
                  <xsl:when test="@IsWheelchair = 'True'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'Junior'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'U19'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'Cadet'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'U16'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y14'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y12'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'Y10'">9999</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet40'">8</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet50'">8</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet60'">8</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet70'">8</xsl:when>
                  <xsl:when test="@AgeLimit = 'Vet80'">8</xsl:when>
                  <xsl:when test="@RatingLimit = 'DivI'">9999</xsl:when>
                  <xsl:when test="@RatingLimit = 'DivIA'">9999</xsl:when>
                </xsl:choose>
              </xsl:if>
            </xsl:variable>

            <SeedStrategy>
              <xsl:attribute name="type">
                <xsl:choose>
                  <xsl:when test="$type='ind'  and $pl1 != '' and (@AgeLimit='Vet40' or @AgeLimit='Vet50' or @AgeLimit='Vet60' or @AgeLimit='Vet70' or @AgeLimit='Vet80')">SeedByRankWithinRating</xsl:when>
                  <xsl:when test="$type='ind'  and $pl1 != ''">SeedByRankAndRating</xsl:when>
                  <xsl:when test="$type='ind'  and $pl1  = ''">SeedByRating</xsl:when>
                  <xsl:when test="$type='team' and $pl1 != ''">SeedByUsfaTeamFormula</xsl:when>
                  <xsl:when test="$type='team' and $pl1  = ''">SeedByTeamRanks</xsl:when>
                </xsl:choose>
              </xsl:attribute>
              <PointList1>
                <xsl:if test="$pl1 != ''"><xsl:value-of select="$pl1" /></xsl:if>
                <xsl:if test="$pl1 = ''">0</xsl:if>
              </PointList1>
              <PointList2 />
              <NumProt>
                <xsl:if test="$prot != ''"><xsl:value-of select="$prot" /></xsl:if>
                <xsl:if test="$prot = ''">0</xsl:if>
              </NumProt>
              <AllowSwapProt>True</AllowSwapProt>
              <SeedFromEventID />
            </SeedStrategy>

            <ArrayOfCompetitor>
              <!-- Individual registrations -->
              <xsl:for-each select="usfa:Reg">
                <Competitor id="{position()}" type="ind">
                  <EventFeePaid><xsl:value-of select="@EventFeePaid" /></EventFeePaid>
                  <CheckInState>Absent</CheckInState>
                  <MemAuth>USFA</MemAuth>
                  <ArrayOfEventFencer>
                    <xsl:call-template name="EventFencer">
                      <xsl:with-param name="fencer" select="key('FencersByID', @PersonID)" />
                      <xsl:with-param name="weap"   select="$weap" />
                      <xsl:with-param name="pl"     select="substring-after($pl1, ' ')" />
                    </xsl:call-template>
                  </ArrayOfEventFencer>
                </Competitor>
              </xsl:for-each>
              
              <!-- Team registrations -->
              <xsl:for-each select="usfa:TeamReg">
                <Competitor id="{@TeamID}" type="team">
                  <EventFeePaid><xsl:value-of select="@EventFeePaid" /></EventFeePaid>
                  <CheckInState>Absent</CheckInState>
                  <TeamName><xsl:value-of select="@TeamName" /></TeamName>
                  <TeamCaptain><xsl:value-of select="@TeamCaptain" /></TeamCaptain>
                  <TeamFredID><xsl:value-of select="@TeamID" /></TeamFredID>
                  <TeamRegNotes />
                  <TeamRegFeePaid>0</TeamRegFeePaid>
                  <TeamClubID>
                    <xsl:choose>
                      <xsl:when test="@TeamClub and @TeamClub != ''"><xsl:value-of select="@TeamClub" /></xsl:when>
                      <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                  </TeamClubID>
                  <Division>
                    <xsl:if test="@TeamDivision != ''">USFA|<xsl:call-template name="ConvertDivision"><xsl:with-param name="divName" select="@TeamDivision" /></xsl:call-template></xsl:if>
                  </Division>
                  <Country><xsl:value-of select="@TeamCountry" /></Country>
                    
                  <ArrayOfEventFencer>
                    <xsl:for-each select="usfa:TeamFencer">
                      <xsl:call-template name="EventFencer">
                        <xsl:with-param name="fencer" select="key('FencersByID', @PersonID)" />
                        <xsl:with-param name="weap"   select="$weap" />
                        <xsl:with-param name="pl"     select="substring-after($pl1, ' ')" />
                      </xsl:call-template>
                    </xsl:for-each>
                  </ArrayOfEventFencer>
                </Competitor>
              </xsl:for-each>
            </ArrayOfCompetitor>

            <ArrayOfRound>
              <Round type="Registration" num="0">
                <Finished>True</Finished>
                <NumByes>0</NumByes>
                <ArrayOfRoundSeed>
                  <xsl:for-each select="usfa:Reg">
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

      <ArrayOfReferee>
        <xsl:for-each select="/usfa:FencingData/usfa:Tournament/usfa:Referees/usfa:Referee">
          <xsl:call-template name="Referee">
            <xsl:with-param name="person" select="key('FencersByID', @PersonID)" />
          </xsl:call-template>
        </xsl:for-each>
      </ArrayOfReferee>
      
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
    <xsl:param name="pl" />
    
    <EventFencer id="{$fencer/@PersonID}">
      <WeaponRating>
        <xsl:value-of select="$fencer/usfa:WeaponClassifications/usfa:Classification[@Org='USFA' and @Weapon=$weap]" /> 
      </WeaponRating>
      <Rank1>
        <xsl:variable name="rank">
          <xsl:value-of select="$fencer/usfa:WeaponRankings/usfa:Ranking[@Org='USFA' and @Weapon=$weap]" />
        </xsl:variable>
        <xsl:if test="$rank">
          <xsl:value-of select="$rank" />
        </xsl:if>
        <xsl:if test="not($rank)">0</xsl:if>
      </Rank1>   
      <Rank2>0</Rank2>
      <Club1ID>
        <xsl:choose>
          <xsl:when test="$fencer/@Club1 and $fencer/@Club1 != ''"><xsl:value-of select="$fencer/@Club1" /></xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </Club1ID>
      <Club2ID>
        <xsl:choose>
          <xsl:when test="$fencer/@Club2 and $fencer/@Club2 != ''"><xsl:value-of select="$fencer/@Club2" /></xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </Club2ID>

      <Division>
        <xsl:if test="$fencer/@Division != ''">USFA|<xsl:call-template name="ConvertDivision"><xsl:with-param name="divName" select="$fencer/@Division" /></xsl:call-template></xsl:if>
      </Division>
      <Country><xsl:value-of select="$fencer/@Country" /></Country>
    </EventFencer>
  </xsl:template>
  
  <xsl:template name="Referee">
    <xsl:param name="person" />
    
    <Referee id="{position()}">
      <FencerID><xsl:value-of select="$person/@PersonID" /></FencerID>
      <Club1ID>
        <xsl:choose>
          <xsl:when test="$person/@Club1 and $person/@Club1 != ''"><xsl:value-of select="$person/@Club1" /></xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </Club1ID>
      <Club2ID>
        <xsl:choose>
          <xsl:when test="$person/@Club2 and $person/@Club2 != ''"><xsl:value-of select="$person/@Club2" /></xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </Club2ID>
      <Division>
        <xsl:if test="$person/@Division != ''">USFA|<xsl:call-template name="ConvertDivision"><xsl:with-param name="divName" select="$person/@Division" /></xsl:call-template></xsl:if>
      </Division>
      <Country><xsl:value-of select="$person/@Country" /></Country>
      <Country2 />
      <Country3 />
      <Country4 />
      <FoilRating>
        <xsl:value-of select="$person/usfa:RefereeRatings/usfa:Rating[@Org='USFA' and @Weapon='Foil']" /> 
      </FoilRating>
      <EpeeRating>
        <xsl:value-of select="$person/usfa:RefereeRatings/usfa:Rating[@Org='USFA' and @Weapon='Epee']" /> 
      </EpeeRating>
      <SaberRating>
        <xsl:value-of select="$person/usfa:RefereeRatings/usfa:Rating[@Org='USFA' and @Weapon='Saber']" /> 
      </SaberRating>
    </Referee>
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
    <xsl:choose>
      <xsl:when test="@AgeLimit='Senior'">FIE|SR</xsl:when>
      <xsl:when test="@AgeLimit='Junior'">FIE|JR</xsl:when>
      <xsl:when test="@AgeLimit='Cadet'">FIE|CDT</xsl:when>
      <xsl:when test="@AgeLimit='U19'">USFA|U19</xsl:when>
      <xsl:when test="@AgeLimit='U16'">USFA|U16</xsl:when>
      <xsl:when test="@AgeLimit='Y14'">USFA|Y14</xsl:when>
      <xsl:when test="@AgeLimit='Y12'">USFA|Y12</xsl:when>
      <xsl:when test="@AgeLimit='Y10'">USFA|Y10</xsl:when>
      <xsl:when test="@AgeLimit='Y8'">USFA|Y8</xsl:when>
      <xsl:when test="@AgeLimit='VetCombined'">USFA|VET</xsl:when>
      <xsl:when test="@AgeLimit='Vet40'">USFA|V40</xsl:when>
      <xsl:when test="@AgeLimit='Vet50'">FIE|V50</xsl:when>
      <xsl:when test="@AgeLimit='Vet60'">FIE|V60</xsl:when>
      <xsl:when test="@AgeLimit='Vet70'">FIE|V70</xsl:when>
      <xsl:when test="@AgeLimit='Vet80'">USFA|V80</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ConvertDivision">
    <xsl:param name="divName" />
    <xsl:choose>
      <xsl:when test="$divName='US Fencing'">National</xsl:when>
      <xsl:when test="$divName='Border Texas'">Border TX</xsl:when>
      <xsl:when test="$divName='Central California'">Central CA</xsl:when>
      <xsl:when test="$divName='Central Florida'">Central FL</xsl:when>
      <xsl:when test="$divName='Central Pennsylvania'">Central PA</xsl:when>
      <xsl:when test="$divName='Columbus'">Columbus OH</xsl:when>
      <xsl:when test="$divName='Gateway Florida'">Gateway FL</xsl:when>
      <xsl:when test="$divName='Gold Coast Florida'">Gold Coast</xsl:when>
      <xsl:when test="$divName='Green Mountain'">Green Mt.</xsl:when>
      <xsl:when test="$divName='Hudson-Berkshire'">Huds-Berks</xsl:when>
      <xsl:when test="$divName='Inland Empire'">Inland Emp</xsl:when>
      <xsl:when test="$divName='Metropolitan NYC'">Metro NYC</xsl:when>
      <xsl:when test="$divName='Mountain Valley'">Mt. Valley</xsl:when>
      <xsl:when test="$divName='Nebraska-South Dakota'">Nebr-S.Dak</xsl:when>
      <xsl:when test="$divName='North Carolina'">N. Carolina</xsl:when>
      <xsl:when test="$divName='North Texas'">North TX</xsl:when>
      <xsl:when test="$divName='Northeast Pennsylvania'">Northeast PA</xsl:when>
      <xsl:when test="$divName='Northern California'">Northern CA</xsl:when>
      <xsl:when test="$divName='Northern Ohio'">Northern OH</xsl:when>
      <xsl:when test="$divName='Plains Texas'">Plains TX</xsl:when>
      <xsl:when test="$divName='San Bernardino'">San Bern'do</xsl:when>
      <xsl:when test="$divName='South Carolina'">S. Carolina</xsl:when>
      <xsl:when test="$divName='South Jersey'">S. Jersey</xsl:when>
      <xsl:when test="$divName='South Texas'">South TX</xsl:when>
      <xsl:when test="$divName='Southern California'">Southern CA</xsl:when>
      <xsl:when test="$divName='Southwest Ohio'">Southwest OH</xsl:when>
      <xsl:when test="$divName='Utah-Southern Idaho'">Utah-S.Idaho</xsl:when>
      <xsl:when test="$divName='Westchester-Rockland'">West-Rock</xsl:when>
      <xsl:when test="$divName='Western New York'">Western NY</xsl:when>
      <xsl:when test="$divName='Western Pennsylvania'">Western PA</xsl:when>
      <xsl:when test="$divName='Western Washington'">Western WA</xsl:when>
      <xsl:otherwise><xsl:value-of select="$divName" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Event point list abbr -->
  <xsl:template name="ConvertPointList">
    <xsl:param name="pl" />
    <xsl:choose>
      <xsl:when test="$pl='FIE'">FIE SR</xsl:when>
      <xsl:when test="$pl='SR'">USFA SR</xsl:when>
      <xsl:when test="$pl='VET'">USFA VET</xsl:when>
      <xsl:when test="$pl='V40'">USFA V40</xsl:when>
      <xsl:when test="$pl='V50'">USFA V50</xsl:when>
      <xsl:when test="$pl='V60'">USFA V60</xsl:when>
      <xsl:when test="$pl='V70'">USFA V70</xsl:when>
      <xsl:when test="$pl='V80'">USFA V80</xsl:when>
      <xsl:when test="$pl='JNR'">USFA JR</xsl:when>
      <xsl:when test="$pl='CDT'">USFA CDT</xsl:when>
      <xsl:when test="$pl='Y14'">USFA Y14</xsl:when>
      <xsl:when test="$pl='Y12'">USFA Y12</xsl:when>
      <xsl:when test="$pl='Y10'">USFA Y10</xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

