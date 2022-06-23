window.PNM = Object.assign({}, window.PNM, {
  PAEC: {
    catalogue_mesures: [
      0,
      'Respect des défens',
      'Report de pâturage',,
      'Préservation des zones humides',,,,
      'Pâturage renforcé',,,,
      'Maintien d\'ouverture',
      'Ouverture',
      'Pâturage',
      'Raclage maximum 4',
      'Raclage maximum 2',,,,,,,
      'Limitation de passage et de pâturage',
      'Raclage maximum 3',,,,,
      'Protection des pelouses fragiles',,,
      'Report de pâturage et ouverture',
      'Report de pâturage et maintien d\'ouverture',
      'Maintien de la pratique de la fauche'
    ],
    catalogue_mesures_fauche: [],
    upTooltip: (feature, layer) => {
      layer.bindTooltip(`unité pastorale<small> #${feature.properties.id}</small><hr><strong>${
        feature.properties.nom
      }</strong>
<br>${Math.round(feature.properties.surface / 10000)} ha
`);
    },
    prairieTooltip: (feature, layer) => {
      layer.bindTooltip(`prairie<small> #${feature.properties.id}</small><hr>
${Math.round(feature.properties.surface / 1000) / 10} ha
`);
    },
    gestionTooltip: (feature, layer) => {
      layer.bindTooltip(`mesure de gestion<small> #${feature.properties.id} (MAEC #${feature.properties.maec})</small>
<br><strong>${PNM.PAEC.catalogue_mesures[feature.properties.type_mesure]}</strong>
<hr>
${feature.properties.mesure}
<br> <small> ${feature.properties.commentaire}</small>
<br>${Math.round(feature.properties.surface / 1000) / 10} ha

`);
    },
    faucheTooltip: (feature, layer) => {
      layer.bindTooltip(`mesure de fauche<small> #${feature.properties.id}</small>
<br><strong>${PNM.PAEC.catalogue_mesures_fauche[feature.properties.engagement]}</strong>
<hr>
${feature.properties.debut} - ${feature.properties.fin}
<br> <small> ${feature.properties.commentaire}</small>
<br>${Math.round(feature.properties.surface / 1000) / 10} ha

`);
    },
    areaFilter: (feature, context) => {
      let hideout = context.props.hideout;
      let filter = hideout.filtered;
      return filter == null || filter.includes(feature.properties.id);
    },
    upStyle: (feature, context) => {
      if (context.props.hideout.selected == feature.properties.id) {
        return {
          color: "yellow",
          fillOpacity: 0.4,
        };
      }
      if (feature.properties.cp[0] == null) {
        return {
          color: "green",
          fillOpacity: 0.2,
        };
      }
      return {
        color: "green",
        fillOpacity: 0.4,
      };
    },
    prairieStyle: (feature, context) => {
      if (context.props.hideout.selected == feature.properties.id) {
        return {
          color: "orange",
          fillOpacity: 0.4,
        };
      }
      if (feature.properties.mesures[0] == null) {
        return {
          color: "grey",
          fillOpacity: 0.2,
        };
      }
      return {
        color: "brown",
        fillOpacity: 0.4,
      };
    },
    gestionStyle: (feature, context) => {
      if (context.props.hideout.selected == feature.properties.id) {
        return {
          color: "orange",
          fillOpacity: 0.4,
        };
      }
      return {
        color: "purple",
        fillOpacity: 0.4,
      };
    },
    faucheStyle: (feature, context) => {
      if (context.props.hideout.selected == feature.properties.id) {
        return {
          color: "orange",
          fillOpacity: 0.4,
        };
      }
      return {
        color: "blue",
        fillOpacity: 0.4,
      };
    },
  },
});
