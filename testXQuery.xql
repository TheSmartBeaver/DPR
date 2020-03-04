<html>
<body> <ol> {
    for $interv in doc("masterILD.xml")//listeIntervenants/intervenant
    order by $interv/nom
    return(
        <li>{$interv/nom}</li>,
        <ol> {  for $ue in doc("masterILD.xml")//descendant::ue[refintervenant/@ref=data($interv/@id)]
                order by $ue/nom
                return(<li>{$ue/nom}</li>)
        } </ol>,
        <ul> {distinct-values(for $refSemestre in doc("masterILD.xml")//descendant::ue[refintervenant/@ref=data($interv/@id)]/../../@id
                               return(<li>{doc("masterILD.xml")//parcours[ref-semestre/@ref=data($refSemestre)]/nom}</li>)
        )} </ul>
)} </ol> </body>
</html>
