module namespace box = "http://github.com/wendellpiez/XMLLunchbox";

(: declare option db:chop 'no'; :)

(: module code so far not tested 20190130 :)

declare function box:and-sequence($items as item()*) as xs:string {
  string-join(
    for $i at $p in $items
    return
      ( if ($p gt 1) then
          if ($p eq count($items)) then ' and ' else ', '
        else '',
        string($i) ),
    '')
};

(: recursively processes the XSLT pipeline as a sequence of XSLT references (passed in as a list of strings) :)
declare function box:run-xslt-pipeline($source as document-node(),
                                       $stylesheets as xs:string*,
                                       $params as map(*)? )
                 as document-node() {
   if (empty($stylesheets)) then $source
   else
      let $interim := box:run-xslt($source, $stylesheets[1], $params)
      return box:run-xslt-pipeline($interim, remove($stylesheets,1),$params)
};

(: for robustness of execution, to catch Saxon errors (to safely message them) and avoid BaseX runtime errors :)
declare function box:run-xslt($source as document-node(), $stylesheet as xs:string, $params as map(*)?)
                 as document-node()* {
   try { xslt:transform($source, $stylesheet, $params ) }
   catch * { document {
      <EXCEPTION>
        { 'EXCEPTION [' ||  $err:code || '] XSLT failed: ' || $stylesheet || ': ' || normalize-space($err:description) }
      </EXCEPTION>  } }
};
