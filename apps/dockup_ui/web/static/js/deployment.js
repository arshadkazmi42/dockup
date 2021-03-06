import React from "react"
import ReactDOM from "react-dom"
import DeploymentList from "./components/deployment_list"
import DeploymentItem from "./components/deployment_item"
import DeploymentForm from "./components/deployment_form"

let deployment_form_container = document.getElementById('deployment_form_container');

if (deployment_form_container) {
  ReactDOM.render(<DeploymentForm/>, deployment_form_container);
}

const Deployment = {
  mountDeploymentList: (elementId) => {
    let element = document.getElementById(elementId);
    ReactDOM.render(<DeploymentList/>, element);
  },

  mountDeploymentForm: (elementId, whitelistedUrls) => {
    let element = document.getElementById(elementId);
    ReactDOM.render(<DeploymentForm urls={whitelistedUrls}/>, element);
  },

  mountDeploymentItem: (elementId, deploymentJSON) => {
    let element = document.getElementById(elementId);
    let deployment = JSON.parse(deploymentJSON);
    ReactDOM.render(<DeploymentItem deployment={deployment}/>, element);
  },
}

export default Deployment;
