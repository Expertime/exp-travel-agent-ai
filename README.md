# Azure Agents Travel Assistant

This repository contains an end-to-end sample of a travel assistant implemented with Azure Agents Runtime and Bot Framework. The travel assistant leverages the Azure AI platform to understand images and documents, providing assistance during travel planning and common travel situations. Key features include:

- **Image Recognition**: Identify landmarks, extract text from travel documents, and more.
- **Document Understanding**: Parse itineraries, booking confirmations, and other travel-related documents.
- **Travel Assistance**: Offer recommendations, reminders, and support for various travel scenarios.

## Getting Started

To get started with the Azure Agents Travel Assistant, follow the instructions below to set up your environment and run the sample application.

### Prerequisites

- An Azure subscription
- Python 3.10 or later (for running locally)

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Azure-Samples/azureai-travel-agent-python
    cd azureai-travel-agent-python
    ```

2. Deploy the infrastructure and sample app
    ```sh
    azd up
    ```

3. (Optional) Run locally:
    ```sh
    cd src
    pip install -r requirements.txt
    python app.py
    ```

4. (Optional) Open http://localhost:3978/api/messages in the [Bot Framework Emulator](https://github.com/microsoft/BotFramework-Emulator)

## Features

- **Publicly available travel knowledge**: Ask about well-known destinations and tourist attractions
- **Document Upload**: Upload PDF, Word and other document formats and add to File Search to use the information contained as part of the conversation
- **Image Upload**: Upload images and ask questions about the location, landmark or directions
- **Web search**: The Agent may use Bing Search to obtain updated information about certain locations, accomodations, weather and more.

## Guidance

### Regional Availablility

You may deploy this solution on any regions that support Azure AI Agents. Some components, such as Bot Service and Bing Search, are deployed in a global model, and as such are not tied to a single region. Make sure to review Data Residency requirements.

- [Regionalization in Azure AI Bot Service] https://learn.microsoft.com/en-us/azure/bot-service/bot-builder-concept-regionalization?view=azure-bot-service-4.0

### Model Support

This quickstart supports both GPT-4o and GPT-4o-mini. Ohter models may also perform well depending on question complexity. Standard deployments are used by default, but you may update them to Global Standard or Provisioned SKUs after successfully deploying the solution.

### Troubleshooting

- `Message: Invalid subscription ID`: Your subscription may not be enabled for Azure AI Agents. During the preview of this functionality, it may be required to complete additional steps to onboard your subscription to Azure AI Agents. Alternatively, update the .env file (locally) or app service environment variables (on Azure) to point the application to another AI Project.
- `azure.core.exceptions.HttpResponseError: Operation returned an invalid status 'Forbidden'`: Your current user does not have Azure ML Data Scientist role, or your IP is not allowed to access the Azure AI Hub. Review the RBAC and networking configurations of your AI Hub/Project.

## Security

Most of the resources deployed in this template leverage Private Endpoints and Entra ID authentication for enhanced security. Make sure to use the corresponding parameters to use these features.

There are two exceptions to this pattern in this repository:

- Bot Service does not support Entra ID authentication for the Direct Line / Web channel.
- The Bot Framework SDK for Python does not support Entra ID authentication for the Cosmos DB connector.

For this reason, both services utilize API Keys, properly stored in the Key Vault deployed with the quickstart.

## Resources

- [Getting started with Azure OpenAI Assistants (Preview)](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/assistant)
- [Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/overview)
- [Generative AI For Beginners](https://github.com/microsoft/generative-ai-for-beginners)

## How to Contribute

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq) or contact <opencode@microsoft.com> with any additional questions or comments.

## Key Contacts & Contributors

| Contact | GitHub ID | Email |
|---------|-----------|-------|
| Marco Cardoso | @MarcoABCardoso | macardoso@microsoft.com |

## License

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.