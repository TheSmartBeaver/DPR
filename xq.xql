<html>
<body>
<head>
                <meta charset="UTF-8"/>
</head>
<h1>Liste des intervenants du master informatique</h1>
<ol> {
    for $interv in doc("master.xml")//listeIntervenants/intervenant
    order by $interv/nom
    return(
        <li><h2>nom Enseignant : {$interv/nom}</h2></li>,
        <h3>UEs enseignés :</h3>,
        <ol> {  for $ue in doc("master.xml")//descendant::ue[refintervenant/@ref=data($interv/@id)]
                order by $ue/nom
                return(<li>{$ue/nom}</li>)
        } </ol>,
        <h3>parcours attachés :</h3>,
        <ul>{for $p in distinct-values(for $ue in doc("master.xml")//descendant::ue[refintervenant/@ref=data($interv/@id)]
		      return(for $refSemestre in doc("master.xml")//semestre[bloc/ref-ue/@ref=$ue/@id]/@id
				     return(for $parcours in doc("master.xml")//parcours[ref-semestre/@ref=data($refSemestre)]/nom
				             return(data($parcours))
				           )
			        ))
			  return(<li>{data($p)}</li>)
	}</ul>

)} </ol> </body>
</html>
