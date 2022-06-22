window.PNM = Object.assign({}, window.PNM, {
  PAEC: {
    upTooltip: (feature, layer) => {
      layer.bindTooltip(`unité pastorale<hr><strong>${feature.properties.nom}</strong>
<br><small>Id #${feature.properties.id}</small>
`);
    },
    prairieTooltip: (feature, layer) => {
      layer.bindTooltip(`prairie<hr>
<br><small>Id #${feature.properties.id}</small>
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
          fillOpacity: 0.4,
        };
      }
      return {
        color: "grey",
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
      return {
        color: "brown",
        fillOpacity: 0.4,
      };
    },
  },
});
