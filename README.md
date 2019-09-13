# Compliant Coupons

[![Join the chat at https://gitter.im/alice-si/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alice-si/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This project implements a flexible approach for defining a compliance layer around a standard ERC20 token.

### Overview

The first application launched by Alice uses smart contracts to implement a "pay for success" donation model, where donors only pay if the charitable projects they give to achieve their goals.

Each charity project encodes a list of "goals" that the charity aims to achieve, and each goal is assigned a price that the charity will receive if/when the goal is provably achieved.

Donors give to projects on the Alice platform using fiat, and the payment logic is implemented on the blockchain using a stablecoin token pegged to the value of their gift. When a donor sends money to a project, the corresponding amount of tokens is minted and credited by the Charity contract.  These tokens are held in escrow until a dedicated Validator confirms that an expected goal pursued by the charity has been achieved. Once this validation has been performed, the price assigned to the goal is then transferred to the charity's account. If the charity does not achieve any goals, outstanding tokens are unlocked and returned to donors. They can then be reused for future donations.

### Compliant transfer lifecycle

![Compliant transfer lifecycle](/diagrams/compliant-transfer-lifecycle.png)

### Installation

To install all of the necessary dependencies use the node package manager:

    npm install

### Running tests

To run all of the smart contract tests, use the following truffle command in your console:

    npx truffle test

It's advices to use the ganache client for efficient testing

    npx ganache-cli -a 100

## Contributions

All comments and ideas for improvements and pull requests are welcomed. We want to improve the project based on feedback from the community.
