import mailjet.mailjet;

import vibe.core.log;
import std.process : environment;

shared static this()
{
	auto api = createMailjetApi(environment["MAILJET_KEY"], environment["MAILJET_PWD"]);

	immutable senderAddress = MailAddress(environment["MAILJET_TEST_SENDER"], "sender");
	immutable targetAddress = MailAddress(environment["MAILJET_TEST_TARGET"], "");

	OutgoingMessage msg;
	msg.From = senderAddress;
	msg.To = [targetAddress];
	msg.TextPart = "hello {{var:foo}}";
	msg.Variables["foo"] = "bar";
	msg.TemplateLanguage = true;

	auto res = api.send([msg]);
	logInfo("res: %s", res);

	OutgoingMessageTemplated msg2;
	msg2.From = senderAddress;
	msg2.To = [targetAddress];
	msg2.Variables["name"] = "Fooo";
	msg2.TemplateLanguage = true;
	msg2.TemplateID = environment["MAILJET_TEST_TEMPLATE"].to!int;

	auto res2 = api.sendTemplate([msg2]);
	logInfo("res: %s", res2);
}
