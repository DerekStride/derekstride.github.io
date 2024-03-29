---
layout: post
title: How Shopify Dynamically Routes Storefront Traffic
excerpt: >
  Fast continuous integration (CI) time and deployments are great ways to increase the velocity of getting changes into
  production. However, for time-critical use cases like ours removing the CI time and deployment altogether is even
  better.
canonical_url: https://shopify.engineering/dynamically-route-storefront-traffic
---

_This post [originally appeared on the Shopify Engineering
blog](https://shopify.engineering/dynamically-route-storefront-traffic) on April 9, 2021._

<p>In 2019 we set out to <a href="https://shopify.engineering/how-shopify-reduced-storefront-response-times-rewrite" target="_blank" rel="nofollow noopener noreferrer">rewrite the Shopify storefront implementation</a>. Our goal was to make it faster. We talked about the strategies we used to achieve that goal in a previous post about <a href="https://shopify.engineering/simplify-batch-cache-optimized-server-side-storefront-rendering" target="_blank" rel="nofollow noopener noreferrer">optimizing server-side rendering and implementing efficient caching</a>. To build on that post, I’ll go into detail on how the Storefront Renderer team tweaked our load balancers to shift traffic between the legacy storefront and the new storefront.</p>
<p>First, let's take a look at the technologies we used. For our load balancer, we’re running nginx with <a href="https://github.com/openresty/lua-nginx-module" target="_blank" rel="nofollow noopener noreferrer">OpenResty</a>. We previously discussed how scriptable load balancers are our <a href="https://shopify.engineering/surviving-flashes-of-high-write-traffic-using-scriptable-load-balancers-part-i" target="_blank" rel="nofollow noopener noreferrer">secret weapon for surviving spikes of high traffic</a>. We built our storefront verification system with Lua modules and used that system to ensure our new storefront achieved parity with our legacy storefront. The system to permanently shift traffic to the new storefront, once parity was achieved, was also built with Lua. <a href="https://shopify.engineering/implementing-chatops-into-our-incident-management-procedure" target="_blank" rel="nofollow noopener noreferrer">Our chatbot, spy,</a> is our front end for interacting with the load balancers via our control plane.</p>
<p>At the beginning of the project, we predicted the need to constantly update which requests were supported by the new storefront as we continued to migrate features. We decided to build a rule system that allows us to add new routing rules easily.</p>
<p>Starting out, we kept the rules in a Lua file in our nginx repository, and kept the enabled/disabled status in our control plane. This allowed us to quickly disable a rule without having to wait for a deploy if something went wrong. It proved successful, and at this point in the project, enabling and disabling rules was a breeze. However, our workflow for changing the rules was cumbersome, and we wanted this process to be even faster. We decided to store the whole rule as a JSON payload in our control plane. We used spy to create, update, and delete rules in addition to the previous functionality of enabling and disabling the rules. We only needed to deploy nginx to add new functionality.</p>
<h2>The Power of Dynamic Rules</h2>
<p>Fast continuous integration (CI) time and deployments are great ways to increase the velocity of getting changes into production. However, for time-critical use cases like ours removing the CI time and deployment altogether is even better. Moving the rule system into the control plane and using spy to manipulate the rules removed the entire CI and deployment process. We still require a “code review” on enabled spy commands or before enabling a new command, but that’s a trivial amount of time compared to the full deploy process used prior.</p>
<p>Before diving into the different options available for configuration, let’s look at what it’s like to create a rule with spy. Below are three images showing creating a rule, inspecting it, and then deleting it. The rule was never enabled, as it was an example, but that process requires getting approval from another member of the team. We are affecting a large share of real traffic on the Shopify platform when running the command <code>spy storefront_renderer
enable example-rule</code>, so the rules to good code reviews still apply.</p>
<figure style="text-align: left;"><img alt="An example of how to create a
routing rule with spy via slack." style="display: block; margin-left: auto; margin-right: auto;" data-src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage3.png?format=webp&amp;v=1617989454" class=" lazyloaded" src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage3.png?format=webp&amp;v=1617989454">
<figcaption>Adding a rule with spy</figcaption>
</figure>
<figure style="text-align: left;"><img alt="An example of how to describe an
existing rule with spy via slack." style="display: block; margin-left: auto; margin-right: auto;" data-src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage2.png?format=webp&amp;v=1617989454" class=" lazyloaded" src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage2.png?format=webp&amp;v=1617989454">
<figcaption>Displaying a rule with spy</figcaption>
</figure>
<figure style="text-align: left;"><img alt="An example of how to describe an
existing rule with spy via slack." style="display: block; margin-left: auto; margin-right: auto;" data-src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage4.png?format=webp&amp;v=1617989454" class=" lazyloaded" src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage4.png?format=webp&amp;v=1617989454">
<figcaption>Removing a rule with spy</figcaption>
</figure>
<h2>Configuring New Rules</h2>
<p>Now let’s review the different options available when creating new rules.</p>
<table width="100%">
<tbody>
<tr>
<td style="width: 24.403%;">
<div><meta charset="utf-8"></div>
<b>Option Name</b>
</td>
<td style="width: 24.597%;"><strong>Description</strong></td>
<td style="width: 15%;"><strong>Default</strong></td>
<td style="width: 26%;">&nbsp;<strong>Example</strong>
</td>
</tr>
<tr>
<td style="width: 24.403%;">
<div><meta charset="utf-8"></div>
<span>rule_name</span>
</td>
<td style="width: 24.597%;">
<div><meta charset="utf-8"></div>
<span>The identifier for the rule.</span>
</td>
<td style="width: 15%;"></td>
<td style="width: 26%;">
<div><meta charset="utf-8"></div>
<span>products-json</span>
</td>
</tr>
<tr>
<td style="width: 24.403%;">
<div><meta charset="utf-8"></div>
<span>filters</span>
</td>
<td style="width: 24.597%;">
<div><meta charset="utf-8"></div>
<span>A comma-separated list of filters.</span>
</td>
<td style="width: 15%;"></td>
<td style="width: 26%;">
<div><meta charset="utf-8"></div>
<span>is_product_list_json_read</span>
</td>
</tr>
<tr>
<td style="width: 24.403%;">shop_ids</td>
<td style="width: 24.597%;">
<div><meta charset="utf-8"></div>
<span>A comma-separated list of shop ids to which the rule applies.</span>
</td>
<td style="width: 15%;">all</td>
<td style="width: 26%;"></td>
</tr>
</tbody>
</table>
<p>The <code>rule_name </code>is the identifier we use. It can be any string, but it’s usually descriptive of the type of request it matches.</p>
<p>The <code>shop_ids</code> option lets us choose to have a rule target all shops or target a specific shop for testing. For example, test shops allow us to test changes without affecting real production data. This is useful to test rendering live requests with the new storefront because verification requests happen in the background and don’t directly affect client requests.</p>
<p>Next, the <code>filters</code> option determines which requests would match that rule. This allows us to partition the traffic into smaller subsets and target individual controller actions from our legacy Ruby on Rails implementation. A change to the filters list does require us to go through the full deployment process. They are kept in a Lua file, and the filters option is a comma-separated list of function names to apply to the request in a functional style. If all filters return true, then the rule will match that request.<br>
<script src="https://gist.github.com/DerekStride/464b64f7421371ea6fbcec5bc21caea6.js"></script>

<p></p>
<p>Above is an example of a filter, <code>is_product_list_path</code>, that lets us target HTTP GET requests to the storefront products JSON API implemented in Lua.</p>
<table width="572" height="261">
<tbody>
<tr>
<td style="text-align: left; width: 126px;">
<div style="text-align: center;"><b>Option Name</b></div>
</td>
<td style="text-align: left; width: 268px;">
<div><b>Description</b></div>
</td>
<td style="text-align: left; width: 52px;">
<div><b>Default</b></div>
</td>
<td style="text-align: left; width: 62px;">
<div><b>Example</b></div>
</td>
</tr>
<tr style="text-align: center;">
<td style="text-align: left; width: 126px;">
<div><span style="font-weight: 400;">render_rate</span></div>
</td>
<td style="text-align: left; width: 268px;">
<div><span style="font-weight: 400;">The rate at which we render allowed requests.</span></div>
</td>
<td style="text-align: left; width: 52px;">
<div><span style="font-weight: 400;">0</span></div>
</td>
<td style="text-align: left; width: 62px;">
<div><span style="font-weight: 400;">1</span></div>
</td>
</tr>
<tr style="text-align: center;">
<td style="text-align: left; width: 126px;">
<div><span style="font-weight: 400;">verify_rate</span></div>
</td>
<td style="text-align: left; width: 268px;">
<div><span style="font-weight: 400;">The rate at which we verify requests.</span></div>
</td>
<td style="text-align: left; width: 52px;">
<div><span style="font-weight: 400;">0</span></div>
</td>
<td style="text-align: left; width: 62px;">
<div><span style="font-weight: 400;">0</span></div>
</td>
</tr>
<tr style="text-align: center;">
<td style="text-align: left; width: 126px;">
<div><span style="font-weight: 400;">reverse_verify_rate</span></div>
</td>
<td style="text-align: left; width: 268px;">
<div><span style="font-weight: 400;">The rate at which requests are reverse-verified when rendering from the new storefront.</span></div>
</td>
<td style="text-align: left; width: 52px;">
<div><span style="font-weight: 400;">0</span></div>
</td>
<td style="text-align: left; width: 62px;">
<div><span style="font-weight: 400;">0.001</span></div>
</td>
</tr>
</tbody>
</table>

<p><code>Both render_rate</code> and <code>verify_rate</code> allow us to target a percentage of traffic that matches a rule. This is useful for doing gradual rollouts of rendering a new endpoint or verifying a small sample of production traffic.</p>
<p>The&nbsp;<code>reverse_verify_rate</code> is the rate used when a request is already being rendered with the new storefront. It lets us first render the request with the new storefront and then sends the request to the legacy implementation asynchronously for verification. We call this scenario a reverse-verification, as it’s the opposite or reverse of the original flow where the request was rendered by the legacy storefront then sent to the new storefront for verification. We call the opposite flow forward-verification. We use forward-verification to find issues as we implement new endpoints and reverse-verifications to help detect and track down regressions.</p>
<div>
<table width="562" height="159">
<tbody>
<tr>
<td style="width: 100px; text-align: left;">
<p style="text-align: center;"><b>Option Name</b></p>
</td>
<td style="width: 294px; text-align: left;">
<p><b>Description</b></p>
</td>
<td style="width: 52px; text-align: left;">
<p><b>Default</b></p>
</td>
<td style="width: 62px; text-align: left;">
<p><b>Example</b></p>
</td>
</tr>
<tr style="text-align: center;">
<td style="width: 100px; text-align: left;">
<p><span style="font-weight: 400;">self_verify_rate</span></p>
</td>
<td style="width: 294px; text-align: left;">
<p><span style="font-weight: 400;">The rate at which we verify requests in the nearest region.</span></p>
</td>
<td style="width: 52px; text-align: left;">
<p><span style="font-weight: 400;">0</span></p>
</td>
<td style="width: 62px; text-align: left;">
<p><span style="font-weight: 400;">0.001</span></p>
</td>
</tr>
</tbody>
</table>
</div>
<p>&nbsp;</p>
<p>Now is a good time to introduce self-verification and the associated <code>self_verify_rate</code>. One limitation of the legacy storefront implementation was due to how our <a href="https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale" target="_blank" rel="nofollow noopener noreferrer">architecture for a Shopify pod</a> meant that only one region had access to the MySQL writer at any given time. This meant that all requests had to go to the active region of a pod. With the new storefront, we decoupled the storefront rendering service from the database writer and now serve storefront requests from any region where a MySQL replica is present.</p>
<p>However, as we started decoupling dependencies on the active region, we found ourselves wanting to verify requests not only against the legacy storefront but also against the active and passive regions with the new storefront. This led us to add the <code>self_verify_rate</code> that allows us to sample requests bound for the active region to be verified against the storefront deployment in the local region.</p>
<p>We have found the routing rules flexible, and it made it easy to add new features or prototypes that are usually quite difficult to roll out. You might be familiar with how we <a href="https://shopify.engineering/performance-testing-shopify" target="_blank" rel="nofollow noopener noreferrer">generate load for testing the system's limits</a>. However, these load tests will often fall victim to our load shedder if the system gets overwhelmed. In this case, we drop any request coming from our load generator to avoid negatively affecting a real client experience. Before BFCM 2020 we wondered how the application behaved if the connections to our dependencies, primarily Redis, went down. We wanted to be as resilient as possible to those types of failures. This isn’t quite the same as testing with a load generation tool because these tests could affect real traffic. The team decided to stand up a whole new storefront deployment, and instead of routing any traffic to it, we used the verifier mechanism to send duplicate requests to it. We then disconnected the new deployment from Redis and turned our load generator on max. Now we had data about how the application performed under partial outages and were able to dig into and improve resiliency of the system before BFCM. These are just some of the ways we leveraged our flexible routing system to quickly and transparently change the underlying storefront implementation.</p>
<h2>Implementation</h2>
<p>I’d like to walk you through the main entry point for the storefront Lua module to show more of the technical implementation. First, here is a diagram showing where each nginx directive is executed during the request processing.</p>
<figure style="text-align: left;"><img alt="A flow chart showing the order
different Lua callbacks are run in the nginx request lifecycle." data-src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage1.png?format=webp&amp;v=1617989454" class=" lazyloaded" src="https://cdn.shopify.com/s/files/1/0779/4361/files/How_Shopify_Dynamically_Routes_Storefront_Trafficimage1.png?format=webp&amp;v=1617989454">
<figcaption>Order in which nginx directives are run - source: <a href="https://github.com/openresty/lua-nginx-module/blob/master/README.markdown#directives" target="_blank" rel="nofollow noopener noreferrer">github.com/openresty/lua-nginx-module</a></figcaption>
</figure>
<p>During the rewrite phase, before the request is proxied upstream to the rendering service, we check the routing rules to determine which storefront implementation the request should be routed to. After the check during the header filter phase, we check if the request should be forward-verified (if the request went to the legacy storefront) or reverse-verified (if it went to the new storefront). Finally, if we’re verifying the request (regardless of forward or reverse) in the log phase, we queue a copy of the original request to be made to the opposite upstream after the request cycle has completed.</p>
<script src="https://gist.github.com/ShopifyEng/70c9ecb47a56762ba29196f9c1a23bee.js"></script>

<p>In the above code snippet, the renderer module referenced in the rewrite phase and the header filter phase and the verifier module reference in the header filter phase and log phase, use the same function <code>find_matching_rule</code> from the storefront rules module below to get the matching rule from the control plane. The <code>routing_method</code> parameter is passed in to determine whether we’re looking for a rule to match for rendering or for verifying the current request.</p>
<script src="https://gist.github.com/ShopifyEng/03edfb12d3c6c5ae07290b2197944d33.js"></script>

<p>Lastly, the verifier module uses nginx timers to send the verification request out of band of the original request so we don’t leave the client waiting for both upstreams. The <code>send_verification_request_in_background</code> function shown below is responsible for queuing the verification request to be sent. To duplicate the request and verify it, we need to keep track of the original request arguments and the response state from either the legacy storefront (in the case of a forward verification request) or the new storefront (in the case of a reverse verification request). This will then pass them as arguments to the timer since we won’t have access to this information in the context of the timer.</p>
<script src="https://gist.github.com/ShopifyEng/32e22dd2c13d68c7ba6f96ba1e5a7ca6.js"></script>

<h2>The Future of Routing Rules</h2>
<p>At this point, we're starting to simplify this system because the new storefront implementation is serving almost all storefront traffic. We’ll no longer need to verify or render traffic with the legacy storefront implementation once the migration is complete, so we'll be undoing the work we’ve done and going back to the hardcoded rules approach of the early days of the project. Although that doesn’t mean the routing rules are going away completely, the flexibility provided by the routing rules allowed us to build the verification system and stand up a separate deployment for load testing. These features weren’t possible before with the legacy storefront implementation. While we won’t be changing the routing between storefront implementations, the rule system will evolve to support new features.</p>
