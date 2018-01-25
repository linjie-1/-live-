import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd';

import EditableCell from './EditableCell';

const FormItem = Form.Item;

const columns = [{
  title: '地址',
  dataIndex: 'address',
  key: 'address',
}, {
  title: '薪水',
  dataIndex: 'salary',
  key: 'salary',
}, {
  title: '上次支付',
  dataIndex: 'lastPaidDay',
  key: 'lastPaidDay',
}, {
  title: '操作',
  dataIndex: '',
  key: 'action'
}];

class EmployeeList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      employees: [],
      showModal: false
    };

    columns[1].render = (text, record) => (
      <EditableCell
        value={this.props.web3.fromWei(text, "ether")}
        onChange={ this.updateEmployee.bind(this, record.address) }
        web3={this.props.web3}
      />
    );

    columns[3].render = (text, record) => (
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account, web3 } = this.props;
    payroll.checkInfo.call({
      from: account
    }).then((result) => {
      const employeeCount = result[2].toNumber();

      if (employeeCount === 0) {
        this.setState({loading: false});
        return;
      }

      this.loadEmployees(employeeCount);
    });

  }

  loadEmployees(employeeCount) {
    const { payroll, account } = this.props;
    var requests = [];
    for (var i = 0; i < employeeCount; ++i) {
      requests.push(payroll.checkEmployee.call(i));
    }

    Promise.all(requests).then(values => {
      const employees = values.map(value => ({
        'address': value[0],
        'salary': value[1].valueOf(),
        'lastPaidDay': new Date(value[2].valueOf() * 1000).toString(),
        'key': value[0],
      }));

      this.setState({
        employees: employees,
        loading: false
      });
    });
  }

  addEmployee = () => {
    const { address, salary, employees } = this.state;
    const { payroll, account, web3 } = this.props;
    payroll.addEmployee(address, salary, {from: account}).then(() => {
      this.setState({
        address: '',
        salary: '',
        showModal: false,
        employees: employees.concat({
          address,
          'salary': web3.toWei(salary, "ether"),
          'lastPaidDay': new Date().toString(),
          'key': address,
        })
      });
    });
  }

  updateEmployee = (address, salary) => {
    const { payroll, account } = this.props;
    const employees = this.state.employees;
    payroll.updateEmployee(address, salary, {from: account}).then((result) => {
      this.setState({
        employees: employees.map((employee) => {
          if (employee.address == address) {
            employee.salary = salary;
          }
        })
      });
    });
  }

  removeEmployee = (employeeId) => {
    const { payroll, account } = this.props;
    const employees = this.state.employees;
    payroll.removeEmployee(employeeId, {from: account}).then((result) => {
      this.setState({
        employees: employees.filter((employee) => employee.address != employeeId)
      });
    });
  }

  renderModal() {
      return (
      <Modal
          title="增加员工"
          visible={this.state.showModal}
          onOk={this.addEmployee}
          onCancel={() => this.setState({showModal: false})}
      >
        <Form>
          <FormItem label="地址">
            <Input
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
              onChange={salary => this.setState({salary})}
            />
          </FormItem>
        </Form>
      </Modal>
    );

  }

  render() {
    const { loading, employees } = this.state;
    return (
      <div>
        <Button
          type="primary"
          onClick={() => this.setState({showModal: true})}
        >
          增加员工
        </Button>

        {this.renderModal()}

        <Table
          loading={loading}
          dataSource={employees}
          columns={columns}
        />
      </div>
    );
  }
}

export default EmployeeList
