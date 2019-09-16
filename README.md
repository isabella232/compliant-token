# Compliant Token Wrapper

[![Join the chat at https://gitter.im/alice-si/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alice-si/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This project implements a flexible approach for defining a compliance layer around a standard ERC20 token.

### Overview

Standard ERC-20 face a problem with mainstream adoption due to the scepticism of many regulatory bodies driven by the lack
of built-in mechanism to enforce compliance with the governing financial laws.

To mitigate such concerns and boost the token adoption by institutional users we decided to design a framework allowing
token designers to easily define and implement restriction coming from the traditional financial world.

This solution may be seen as complementary to the (ERC-1400)[https://thesecuritytokenstandard.org/] security token standard by
focusing on a preventive side and enforcing that non-compliant transfer cannot be executed rather than allowing regulators to intervene
only after something went wrong.

The first use case will be adopting [Alice](https://alice.si) social impact bonds coupons to be tradable in a compliant way so they may be
more accessible to traditional institutional investors.


### Architecture

![Compliant transfer lifecycle](/diagrams/architecture.png)

Any ERC-20 token may become compliant by extending the [ComplianceWrapper contract](https://github.com/alice-si/compliant-token/blob/master/contracts/PreventiveComplianceWrapper.sol). This contract intercepts any transfer
attempts and invokes the [PolicySelector](https://github.com/alice-si/compliant-token/tree/master/contracts/selectors) to choose the appropriate compliance policy based on transfer parameters such as an investor type.
A selected [Policy](https://github.com/alice-si/compliant-token/blob/master/contracts/TransferPolicy.sol) is a set of [Checkers](https://github.com/alice-si/compliant-token/tree/master/contracts/checkers) which express rules and restrictions modelled after a real-world financial environment.

### Compliant transfer lifecycle

![Compliant transfer lifecycle](/diagrams/lifecycle.png)

At every transfer executed on a compliant token a [wrapper](https://github.com/alice-si/compliant-token/blob/master/contracts/PreventiveComplianceWrapper.sol)
intercept the attempt and automatically classify to be verified by appropriate compliance [policy](https://github.com/alice-si/compliant-token/blob/master/contracts/TransferPolicy.sol).
The selected policy contains a set of [checkers](https://github.com/alice-si/compliant-token/blob/master/contracts/checkers/ITransferChecker.sol) that validates if transfer parameters are compliant.
If the parameters go through all of the verification the mediating checkers are updated to being able to take into account trading history for subsequent verification.

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
