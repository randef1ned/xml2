roundtrip_xml <- function(x, as_list_version = 1) {
  xml <- read_xml(x)
  lst <- if (as_list_version > 1) as_list2(xml) else as_list(xml)
  xml2 <- as_xml_document(lst)
  expect_equal(as.character(xml), as.character(xml2))
}

test_that("roundtrips with single children", {
  roundtrip_xml("<a><b/></a>")

  roundtrip_xml("<a><b><c/></b></a>")

  roundtrip_xml("<a><b>foo<c/></b></a>")

  roundtrip_xml("<a><b>foo<c>bar</c></b></a>")

  roundtrip_xml("<a x = '1'><b y = '2'>foo<c z = '3'>bar</c></b></a>")
})

test_that("roundtrips with multi children", {
  roundtrip_xml("<a><b1/><b2/></a>")

  roundtrip_xml("<a><b><c1/><c2/></b></a>")

  roundtrip_xml("<a><b1>foo<c/></b1><b2>bar<c/></b2></a>")

  roundtrip_xml("<a><b>foo<c>bar</c><c>baz</c></b></a>")

  roundtrip_xml("<a x = '1'><b y = '2'>foo<c z = '3'>bar</c></b></a>")
  roundtrip_xml("<a x = '1'><b y = '2'>foo<c z = '3'>bar</c></b><c zz = '4'>baz</c></a>")
})

test_that("rountrips with special attributes", {
  roundtrip_xml("<a names = 'test'><b/></a>")
})

test_that("rountrips with only one element", {
  roundtrip_xml("<foo>bar</foo>")
  roundtrip_xml("<foo>bar</foo>", as_list_version = 2)
})

test_that("more than one root node is an error", {
  expect_error(as_xml_document(list(a = list(), b = list())), "Root nodes must be of length 1")
})

test_that("Can convert nodes with leading and trailing text", {
  roundtrip_xml("<a>foo<b>bar</b>baz</a>")
})
