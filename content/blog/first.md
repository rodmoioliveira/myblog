+++
title = "My first post"
date = 2019-11-27
+++

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vitae dapibus sem. Praesent et quam non augue faucibus luctus. Morbi accumsan a justo sit amet luctus. Pellentesque euismod augue eget erat tristique lobortis eget fringilla odio. Vestibulum sit amet iaculis sem, nec bibendum lorem. Nulla maximus et odio eget interdum. Donec vel consectetur enim. Integer vitae metus ante. Sed commodo ornare euismod. In hac habitasse platea dictumst. Aenean placerat lobortis enim ac posuere. In in massa urna. Cras tincidunt, metus in venenatis molestie, enim urna consequat purus, id lacinia magna leo ac eros. Nullam gravida eget tortor id lacinia. Cras ut est blandit, pellentesque purus vitae, volutpat risus. Quisque iaculis dui a purus viverra, in facilisis ipsum eleifend.

Suspendisse eget quam congue, euismod risus vitae, egestas enim. Suspendisse lacus mauris, dignissim nec nulla sit amet, pulvinar dapibus ipsum. Nam tristique ex eget tortor finibus pulvinar. Proin erat tellus, cursus ut ornare vitae, varius sed ex. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tortor nunc, elementum non laoreet vitae, laoreet quis nulla. Fusce vel pulvinar metus. Vestibulum vestibulum, justo vel pellentesque scelerisque, elit sem vehicula risus, nec tincidunt tortor lectus et felis. Vestibulum cursus pellentesque massa non pharetra. Sed sit amet risus ac tellus laoreet imperdiet.

Nam egestas neque non est gravida mollis. Donec vitae risus metus. Sed eget ante lacinia diam tempus aliquam quis in diam. Aenean sed ligula laoreet, porta sapien euismod, malesuada justo. Donec mauris enim, condimentum in maximus in, vulputate sit amet ante. Donec facilisis dui venenatis, viverra metus sed, viverra ex. Quisque mollis turpis in porttitor bibendum. Sed ultrices felis scelerisque aliquet aliquam.

```rs,linenos
pub fn handle_pagination(
    count: i64,
    offset: i64,
    limit: i64,
) -> Result<(), errors::MyError> {
    if offset % limit != 0 {
        return Err(errors::MyError::BadOffset);
    };

    let has_items = count > 0;
    let page_total = (count as f64 / limit as f64).ceil() as i64;
    let page_current = if !has_items { 0 } else { (offset / limit) + 1 };

    if page_current > page_total {
        return Err(errors::MyError::BadPagination);
    };

    Ok(())
}
```

Donec tincidunt sem vel nisl efficitur, quis tristique tortor vulputate. Sed quam neque, ornare eget leo vitae, dictum iaculis felis. Proin elementum tortor at nisl mattis lobortis ac sit amet tellus. Morbi pulvinar hendrerit purus mollis aliquam. Nam fermentum augue neque, at varius metus ultrices ac. Quisque vel sapien et eros finibus rutrum in eget lorem. Donec sollicitudin consectetur congue. Sed non turpis et nisl vehicula vestibulum. Mauris tincidunt est urna, eu tincidunt est tempus in. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas tempor ultricies aliquam. Morbi a arcu arcu. Phasellus faucibus luctus nulla, et aliquam dui posuere in. Maecenas bibendum fringilla diam, quis rutrum nunc egestas non. Donec nunc velit, viverra id lorem eget, molestie elementum libero.

Morbi dapibus orci nulla, nec sollicitudin ante malesuada mollis. Proin elit leo, hendrerit eget lorem id, porta laoreet quam. Suspendisse mollis, eros ut malesuada fermentum, odio nisi pulvinar felis, ac feugiat orci metus eget nunc. Pellentesque sit amet tempor ante, et pharetra diam. Proin tortor tellus, finibus tempus placerat eu, bibendum vel nibh. Nam pretium risus nulla, in consequat magna interdum id. Vestibulum sollicitudin, dui sit amet laoreet dapibus, turpis ante finibus diam, at sodales nisl felis at enim. Donec mollis dignissim euismod.

