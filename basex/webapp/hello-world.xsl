<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- Run on hello-world.xml for a small demo -->
    <xsl:template match="/*">
        <h2 xsl:expand-text="true">Greeting <i>{ name() }</i> not recognized</h2>
    </xsl:template>

    <xsl:template priority="2" match="/hello">
        <h1 xsl:expand-text="true">Hello { . }</h1>
    </xsl:template>
    
    
</xsl:stylesheet>