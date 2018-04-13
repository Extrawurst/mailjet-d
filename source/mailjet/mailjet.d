module mailjet.mailjet;

import vibe.web.rest;
import vibe.data.json;
import vibe.http.common : HTTPMethod;

@safe:

///
struct MailAddress
{
    string Email;
    string Name;
}

///
private mixin template OutMessagbaseTemplate()
{
    MailAddress From;
    MailAddress[] To;
    MailAddress[] Cc;
    MailAddress[] Bcc;

    @optional string[string] Variables;
    string Subject;
}

///
struct OutgoingMessageTemplated
{
    mixin OutMessagbaseTemplate;

    @optional bool TemplateLanguage;

    ulong TemplateID;
}

///
struct OutgoingMessage
{
    mixin OutMessagbaseTemplate;

    @optional bool TemplateLanguage;

    string TextPart;
    string HTMLPart;
}

///
struct SendResponse
{
    SentMessage[] Messages;
}

///
struct SentMessage
{
    struct Message
    {
        string Email;
        string MessageUUID;
        long MessageID;
        string MessageHref;
    }

    string CustomID;
    string Status;

    Message[] To;
    Message[] Cc;
    Message[] Bcc;
}

/// see https://dev.mailjet.com/guides/#send-api-v3-1
@path("v3.1/")
interface MailJetApi
{
    /// see https://dev.mailjet.com/guides/#sending-a-basic-email
    @method(HTTPMethod.POST)
    SendResponse send(OutgoingMessage[] messages);

    /// see https://dev.mailjet.com/guides/#using-a-template
    @method(HTTPMethod.POST)
    @path("send")
    SendResponse sendTemplate(OutgoingMessageTemplated[] messages);
}

///
MailJetApi createMailjetApi(string pub_key, string priv_key)
{
    import vibe.http.client : HTTPClientRequest;
    import std.format : format;

    immutable baseurl = format("https://%s:%s@api.mailjet.com/", pub_key, priv_key);

    return new RestInterfaceClient!MailJetApi(baseurl);
}
