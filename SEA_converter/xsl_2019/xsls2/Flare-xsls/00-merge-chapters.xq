declare option saxon:output "method=xml";
declare option saxon:output "omit-xml-declaration=yes";
declare variable $chapterlist := doc("../HTML.mcbook")/MadCapBook/Chapter/@Link;
declare function local:copy($element as element()) as element()
{
   element { node-name($element) }
   {  $element/@*,
      for $child in $element/node()
      return
        if ($child instance of element())
        then local:copy($child)
        else $child
   }
};

let $root := ( 
	for $chapter in $chapterlist
	return doc(concat("../", $chapter))
)
return
<root>
{
	('&#xA;',
		for $t1 in $root/*
		return ( local:copy($t1), '&#xA;' )
	)
}
</root>
