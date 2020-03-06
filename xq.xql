<html>
<body>
<h1>Liste des intervenants du master informatique</h1>
<ol> {
    for $interv in doc("master.xml")//listeIntervenants/intervenant
    order by $interv/nom
    return(
        <li>{$interv/nom}</li>,
        <h3>UEs enseignés :</h3>,
        <ol> {  for $ue in doc("master.xml")//descendant::ue[refintervenant/@ref=data($interv/@id)]
                order by $ue/nom
                return(<li>{$ue/nom}</li>)
             } </ol>,
        <h3>parcours attachés :</h3>,
        <ul> {for $refSemestre in doc("master.xml")//descendant::ue[refintervenant/@ref=data($interv/@id)]/../../@id
                order by $refSemestre/nom
                return(
                    <li>,
                    distinct-values(for $parcours in doc("master.xml")//parcours[ref-semestre/@ref=data($refSemestre)]/nom
                    order by $parcours
                    return({$parcours}),
                    </li>
                )} </ul>
        }
)} </ol> </body>
</html>
