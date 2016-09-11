import React, {Component} from 'react';
import $ from 'jquery';
import GithubUrlInput from './github_url_input';
import GitUrlInput from './git_url_input';
import FlashMessage from '../flash_message';

class DeploymentForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      gitUrl: "",
      branch: "",
      gitUrlType: "github" // Can be either "github" or "generic"
    }
  }

  handleDeployClick(e) {
    e.preventDefault();
    let xhr = this.createRequest();
    xhr.done(() => {
      FlashMessage.showMessage("success", "Deployment was successfully queued.");
    });
    xhr.fail(() => {
      FlashMessage.showMessage("danger", "Deployment cannot be queued.");
    });
  }

  createRequest() {
    return $.ajax({
      url: '/api/deployments',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        git_url: this.state.gitUrl,
        branch: this.state.branch,
        callback_url: null
      })
    });
  }

  handleUrlChange(url) {
    this.setState({gitUrl: url});
  }

  handleBranchChange(branch) {
    this.setState({branch: branch});
  }

  handleUrlTypeChange(urlType) {
    this.setState({gitUrl: ""});
    this.setState({gitUrlType: urlType});
  }

  validInputs() {
    return (this.state.gitUrl.length > 0 && this.state.branch.length > 0);
  }

  renderGitUrlInput() {
    if(this.state.gitUrlType == "github") {
      return <GithubUrlInput onUrlChange={this.handleUrlChange.bind(this)} onUrlTypeChange={this.handleUrlTypeChange.bind(this)}/>;
    } else {
      return <GitUrlInput onUrlChange={this.handleUrlChange.bind(this)} onUrlTypeChange={this.handleUrlTypeChange.bind(this)}/>;
    }
  }

  render() {
    return (
      <div>
        <form role="form">
          {this.renderGitUrlInput()}
          <div className="form-group">
            <label htmlFor="branch">Branch</label>
            <input className="form-control" id="branch" onChange={(event) => { this.handleBranchChange(event.target.value)}}/>
          </div>
          <button type="submit" onClick={this.handleDeployClick.bind(this)} disabled={!this.validInputs()} className="btn btn-default">Deploy</button>
        </form>
      </div>
    )
  }
}

export default DeploymentForm
