<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">

  <xsl:template name="BuildFencerName">
    <xsl:param name="first" />
    <xsl:param name="middle" />
    <xsl:param name="last" />
    <xsl:param name="suffix" />
    <xsl:param name="nick" />

    <xsl:value-of select="$last" />
    <xsl:if test="$suffix != ''">
      <xsl:text xml:space="preserve"> </xsl:text>
      <xsl:value-of select="$suffix" />
    </xsl:if>

    <xsl:if test="$first != '' or $nick != ''">
      <xsl:text xml:space="preserve">, </xsl:text>
      <xsl:if test="$nick = ''">
        <xsl:value-of select="$first" />
      </xsl:if>
      <xsl:if test="$nick != ''">
        <xsl:value-of select="$nick" />
      </xsl:if>

      <xsl:if test="$middle != ''">
        <xsl:text xml:space="preserve"> </xsl:text>
        <xsl:value-of select="substring($middle, 1, 1)" />
        <xsl:text xml:space="preserve">.</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="BuildClubNames">
    <xsl:param name="club1Abbr" />
    <xsl:param name="club2Abbr" />

    <xsl:if test="$club1Abbr != ''"><xsl:value-of select="$club1Abbr" /></xsl:if>

    <xsl:if test="$club2Abbr != ''">
      <xsl:if test="$club1Abbr != ''">
        <xsl:text xml:space="preserve"> / </xsl:text>
      </xsl:if>
      <xsl:if test="$club1Abbr = ''">
        <xsl:text xml:space="preserve">UNAT / </xsl:text>
      </xsl:if>
      <xsl:value-of select="$club2Abbr" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="BuildAffiliations">
    <xsl:param name="showClub" />
    <xsl:param name="clubAbbr" />
    <xsl:param name="showDiv" />
    <xsl:param name="divAbbr" />
    <xsl:param name="showCountry" />
    <xsl:param name="countryAbbr" />
    <xsl:param name="flagPath" />

    <xsl:if test="$showClub = 'true' and $clubAbbr != ''">
      <xsl:value-of select="$clubAbbr" />
    </xsl:if>

    <xsl:if test="$showDiv = 'true' and $divAbbr != ''">
      <xsl:if test="$showClub = 'true' and $clubAbbr != ''">
        <xsl:text xml:space="preserve"> / </xsl:text>
      </xsl:if>
      <xsl:value-of select="$divAbbr" />
    </xsl:if>

    <xsl:if test="$showCountry = 'true' and $countryAbbr != ''">
      <xsl:if test="($showClub = 'true' and $clubAbbr != '') or ($showDiv = 'true' and $divAbbr != '')">
        <xsl:text xml:space="preserve"> / </xsl:text>
      </xsl:if>

      <img src="{$flagPath}\Flags\{$countryAbbr}.png" />
      <xsl:text xml:space="preserve">  </xsl:text>
      <xsl:value-of select="$countryAbbr" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="FormatTime">
    <xsl:param name="time" />
    <xsl:param name="lang" />

    <xsl:if test="$time != '' and $time != '0001-01-01T00:00:00'">
      <xsl:variable name="hour" select="number(substring($time, 1, 2))" />
      <xsl:variable name="min"  select="substring($time, 4, 2)" />

      <!-- 12-hour format -->
      <xsl:if test="$lang = 'en-US'">
        <xsl:choose>
          <xsl:when test="$hour = 0">
            12:<xsl:value-of select="$min" /> AM
          </xsl:when>
          <xsl:when test="$hour &lt; 12">
            <xsl:value-of select="$hour"/>:<xsl:value-of select="$min" /> AM
          </xsl:when>
          <xsl:when test="$hour = 12">
            12:<xsl:value-of select="$min" /> PM
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$hour - 12"/>:<xsl:value-of select="$min" /> PM
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <!-- 24-hour format -->
      <xsl:if test="$lang != 'en-US'">
        <xsl:value-of select="$hour"/>:<xsl:value-of select="$min" />
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="FormatString">
    <xsl:param name="localized" />
    <xsl:param name="id" />
    <xsl:param name="arg1" />
    <xsl:param name="arg2" />
    <xsl:param name="arg3" />
    <xsl:param name="arg4" />

    <xsl:variable name="text" select="$localized/ft:LocText[@id=$id]" />

    <xsl:variable name="newtext1">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$text" />
        <xsl:with-param name="replace" select="'%1'" />
        <xsl:with-param name="by" select="$arg1" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="newtext2">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$newtext1" />
        <xsl:with-param name="replace" select="'%2'" />
        <xsl:with-param name="by" select="$arg2" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="newtext3">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$newtext2" />
        <xsl:with-param name="replace" select="'%3'" />
        <xsl:with-param name="by" select="$arg3" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="newtext4">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$newtext3" />
        <xsl:with-param name="replace" select="'%4'" />
        <xsl:with-param name="by" select="$arg4" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$newtext4" />
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"    select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by"      select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
  
</xsl:stylesheet>
