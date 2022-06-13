window.PNM = Object.assign({}, window.PNM, {
  PAEC: {
    UPTooltip: (feature, layer) => {
      layer.bindTooltip(`unité pastorale<hr><strong>${feature.properties.nom}</strong>
<br><small>Id #${feature.properties.id}</small>
`);
    },
    prairieTooltip: (feature, layer) => {
      layer.bindTooltip(`prairie<hr>
<br><small>Id #${feature.properties.id}</small>
`);
    },
  },
});
