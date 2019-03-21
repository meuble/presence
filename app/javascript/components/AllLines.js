import React from "react"
import PropTypes from "prop-types"
class AllLines extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      lines: []
    };
  }
  
  render () {
    var lines = this.state.lines.map((line) => {
      return(
       <tr key={line.id}>
        <td>{line.type}</td>
        <td>{line.applies_on}</td>
        <td>{line.electricity_metric}</td>
        <td>{line.water_metric}</td>
        <td>{line.user.name}</td>
       </tr>
      )
     })
    return (
      <React.Fragment>
        <h1>List all lines: </h1>
        <table>
          <thead>
            <th>Type</th>
            <th>Apply on</th>
            <th>Electricity metric</th>
            <th>Water Metric</th>
            <th>Name</th>
          </thead>
          <tbody>
            {lines}
          </tbody>
        </table>
      </React.Fragment>
    );
  }
  componentDidMount(){
    fetch('/api/v1/lines.json')
      .then((response) => { return response.json() })
      .then((data) => { this.setState({ lines: data }) });
  }
}

AllLines.propTypes = {
  lines: PropTypes.string
};
export default AllLines
