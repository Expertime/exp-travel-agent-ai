# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
from botbuilder.core import ActivityHandler, ConversationState, TurnContext, UserState, MessageFactory


class StateManagementBot(ActivityHandler):
    def __init__(self, conversation_state: ConversationState, user_state: UserState):
        self.conversation_state = conversation_state
        self.user_state = user_state
        self.conversation_data_accessor = self.conversation_state.create_property("ConversationData")


    async def on_turn(self, turn_context: TurnContext):
        await super().on_turn(turn_context)
        # Save any state changes. The load happened during the execution of the Dialog.
        await self.conversation_state.save_changes(turn_context)
        await self.user_state.save_changes(turn_context)
    
    async def send_interim_message(
        self,
        turn_context,
        interim_message,
        stream_sequence,
        stream_id,
        stream_type
    ):
        stream_supported = self.streaming and turn_context.activity.channel_id == "directline"
        update_supported = self.streaming and turn_context.activity.channel_id == "msteams"
        # If we can neither stream or update, return null
        if stream_type == "typing" and not stream_supported and not update_supported:
            return None
        # If we can update messages, do so
        if update_supported:
            if stream_id == None:
                create_activity = await turn_context.send_activity(interim_message)
                return create_activity.id
            else:
                update_message = MessageFactory.text(interim_message)
                update_message.id = stream_id
                update_message.type = "message"
                update_activity = await turn_context.update_activity(update_message)
                return update_activity.id
        # If we can stream messages, do so
        channel_data = {
            "streamId": stream_id,
            "streamSequence": stream_sequence,
            "streamType": "streaming" if stream_type == "typing" else "final"
        }
        message = MessageFactory.text(interim_message)
        message.channel_data = channel_data if stream_supported else None
        message.type = stream_type
        activity = await turn_context.send_activity(message)
        return activity.id